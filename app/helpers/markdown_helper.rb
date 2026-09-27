require "redcarpet"
require "rouge"
require "rouge/plugins/redcarpet"

class MarkdownRenderer < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet # otomatis syntax highlight blok ```cpp

  def block_code(code, language)
    lang = language.presence || "cpp"
    lexer = Rouge::Lexer.find(lang) || Rouge::Lexers::PlainText
    formatter = Rouge::Formatters::HTML.new
    highlighted = formatter.format(lexer.lex(code))

    <<~HTML
      <div class="rounded-xl overflow-hidden shadow-lg my-6 border border-gray-700/50">
        <div class="flex items-center gap-2 bg-[#2d2d2d] px-4 py-2">
          <span class="w-3 h-3 rounded-full bg-red-500"></span>
          <span class="w-3 h-3 rounded-full bg-yellow-500"></span>
          <span class="w-3 h-3 rounded-full bg-green-500"></span>
          <span class="ml-3 text-xs text-gray-400 font-mono uppercase tracking-wide">#{lang}</span>
        </div>
        <pre class="highlight !m-0 p-4 overflow-x-auto text-sm leading-relaxed"><code>#{highlighted}</code></pre>
      </div>
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

    raw_text = text.respond_to?(:to_plain_text) ? text.to_plain_text : text.to_s
    raw_text = sanitize_whitespace(raw_text)

    renderer = MarkdownRenderer.new(filter_html: false, hard_wrap: true)
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

  private

  # Ganti semua varian spasi Unicode aneh (nbsp, em space, zero-width, dst) jadi spasi biasa
  def sanitize_whitespace(text)
    text.gsub(/[\u00A0\u1680\u2000-\u200B\u202F\u205F\u3000\uFEFF]/, ' ')
  end
end
