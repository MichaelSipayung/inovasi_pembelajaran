class CreateLessons < ActiveRecord::Migration[8.1]
  def change
    create_table :lessons do |t|
      t.references :topic, null: false, foreign_key: true
      t.string :title
      t.string :compiler_url
      t.string :hackerrank_url

      t.timestamps
    end
  end
end
