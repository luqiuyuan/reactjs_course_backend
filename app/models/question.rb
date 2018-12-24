class Question < ApplicationRecord

  # ==========================
  # Constants
  # ==========================

  TITLE_LENGTH_MAX = 255
  CONTENT_LENGTH_MAX = 65535

  # ==========================
  # Validations
  # ==========================

  validates :title, presence: true, length: {maximum: TITLE_LENGTH_MAX}
  validates :content, length: {maximum: CONTENT_LENGTH_MAX}
  validates :user, presence: true

  # ==========================
  # Associations
  # ==========================

  belongs_to :user
  has_many :answers
  has_many :likes, as: :likable

end
