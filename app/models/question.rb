class Question < ApplicationRecord

  # ==========================
  # Constants
  # ==========================

  TITLE_LENGTH_MAX = 255

  # ==========================
  # Validations
  # ==========================

  validates :title, presence: true, length: {maximum: TITLE_LENGTH_MAX}
  validates :user, presence: true

  # ==========================
  # Associations
  # ==========================

  belongs_to :user

end
