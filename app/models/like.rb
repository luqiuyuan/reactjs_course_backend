class Like < ApplicationRecord

  # ==========================
  # Validations
  # ==========================

  validates :likable, presence: true
  validates :user, presence: true, uniqueness: { scope: [:likable_id, :likable_type] }

  # ==========================
  # Associations
  # ==========================

  belongs_to :likable, polymorphic: true
  belongs_to :user

end
