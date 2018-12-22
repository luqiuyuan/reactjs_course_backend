class Like < ApplicationRecord

  # ==========================
  # Validations
  # ==========================

  validates :likeable, presence: true

  # ==========================
  # Associations
  # ==========================

  belongs_to :likeable, polymorphic: true

end
