require "redcarpet"
require "rouge"
require "rouge/plugins/redcarpet"

class MarkdownRenderer < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet # otomatis syntax highlight blok ```cpp

  def block_code(code, language)
    lexer = Rouge::Lexer.find(language || "cpp") || Rouge::Lexers::PlainText
    formatter = Rouge::Formatters::HTML.new
    highlighted = formatter.format(lexer.lex(code))

    <<~HTML
      <pre class="rounded-lg bg-gray-900 text-gray-100 p-4 overflow-x-auto text-sm"><code>#{highlighted}</code></pre>
    HTML
  end

  def table(header, body)
    <<~HTML
      <div class="overflow-x-auto my-4">
        <table class="min-w-full border border-gray-200 text-sm">
          <thead class="bg-gray-100">#{header}</thead>
          <tbody>#{body}</tbody>
        </table>
      </div>
    HTML
  end
end

module MarkdownHelper
  def markdown(text)
    return "" if text.blank?

    # ActionText::RichText punya method to_plain_text -> ambil teks mentahnya
    raw_text = text.respond_to?(:to_plain_text) ? text.to_plain_text : text.to_s

    renderer = MarkdownRenderer.new(
      filter_html: false,
      hard_wrap: true
    )

    markdown_parser = Redcarpet::Markdown.new(
      renderer,
      fenced_code_blocks: true,
      tables: true,
      autolink: true,
      strikethrough: true,
      no_intra_emphasis: true
    )

    markdown_parser.render(raw_text).html_safe
  end

  # Untuk teks pendek (soal kuis, opsi jawaban) - tanpa bungkus <p>
  def markdown_inline(text)
    return "" if text.blank?
    html = markdown(text)
    html.to_s.strip.sub(/\A<p>(.*)<\/p>\z/m, '\1').html_safe
  end
end
