class User < ApplicationRecord

  # The model user has secure password
  has_secure_password

  # ==========================
  # Constants
  # ==========================

  EMAIL_LENGTH_MAX = 255
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  PASSWORD_LENGTH_MIN = 6
  PASSWORD_LENGTH_MAX = 50
  NAME_LENGTH_MAX = 50

  # ==========================
  # Validations
  # ==========================

  validates :email, presence: true, length: {maximum: EMAIL_LENGTH_MAX}, uniqueness: true,
                    format: {with: VALID_EMAIL_REGEX}
  validates :password, presence: true, length: {minimum: PASSWORD_LENGTH_MIN, maximum: PASSWORD_LENGTH_MAX}, on: :create
  validates :password, allow_nil: true, length: {minimum: PASSWORD_LENGTH_MIN, maximum: PASSWORD_LENGTH_MAX}, on: :update
  validate :password_validation
  validates :name, length: {maximum: NAME_LENGTH_MAX}

  # ==========================
  # Custom Validations
  # ==========================
  
  def password_validation
    # If password is pure upcase
    if !self.password.blank? && self.password.upcase == self.password
      self.errors.add(:password, :should_contain_downcase)
    end

    # If password is pure downcase
    if !self.password.blank? && self.password.downcase == self.password
      self.errors.add(:password, :should_contain_upcase)
    end
  end
  
  # ==========================
  # Callbacks
  # ==========================

  before_save {
    self.email = email.downcase
  }

  # ==========================
  # Custom Methods
  # ==========================

  # return the has digest of the given string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

end
