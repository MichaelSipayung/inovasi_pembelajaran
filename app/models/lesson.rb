class Lesson < ApplicationRecord
  belongs_to :topic
  has_rich_text :content
  has_many :questions, dependent: :destroy
  has_many :submissions, dependent: :destroy
end
