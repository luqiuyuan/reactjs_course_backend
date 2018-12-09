class Answer < ApplicationRecord

  # ==========================
  # Constants
  # ==========================

  CONTENT_LENGTH_MAX = 255

  # ==========================
  # Validations
  # ==========================

  validates :content, presence: true, length: {maximum: CONTENT_LENGTH_MAX}
  validates :question, presence: true
  validates :user, presence: true

  # ==========================
  # Associations
  # ==========================

  belongs_to :question
  belongs_to :user

end
