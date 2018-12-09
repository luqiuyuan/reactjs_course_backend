class UserToken

  include ActiveModel::Validations

  attr_reader :user_id, :key, :expire_in

  # Define constants
  BASE64_N = 64
  ACCESS_TOKEN_EXPIRE = 2592000 # 30 days
  HASH_SALT = "He#ad]fdwdsE3$%^fd!?fdsoiewjqjlfJKOUR*&jfel)kewls&*ew(fdncv"

  def initialize(user)
  	self.user_id = user.id
  	self.key = SecureRandom.base64(BASE64_N)
  	self.expire_in = ACCESS_TOKEN_EXPIRE
    self.user_email = user.email
  end

  # Save user token
  #
  # @return [Boolean] true if saved successfully, false if not
  def save
  	if !valid?
  		return false
  	end

  	# Setup in Redis database
    $redis.set(UserToken.digest(key, user_email), user_id, ex:expire_in)
    return true
  end

  # Delete the user token
  #
  # @params [Fixnum || String] user_id CANNOT be nil
  # @params [String] key CANNOT be nil
  #
  # @raise ActiveRecord::RecordNotFound if user with user_id does not exist
  #
  # comments:
  # The returned value seems 1 if the key exists, 0 otherwise. However, the returned value does not really matter for this method.
  def UserToken.del(user_id, key)
    user = User.find(user_id)
    $redis.del(UserToken.digest(key, user.email))
  end

  # Authenticate user token
  #
  # @param Integer user_id
  # @param String key
  #
  # @return [Boolean] true if authenticated successfully, false if not
  def UserToken.authenticate(user_id, key)
    user = User.find(user_id)
    value = $redis.get(UserToken.digest(key, user.email))
    if value == user_id.to_s
      return true
    else
      return false
    end
  rescue ActiveRecord::RecordNotFound
    return false
  end

  # Refresh user token
  #
  # @param Integer user_id
  # @param String key
  #
  # @raise ActiveRecord::RecordNotFound if user with user_id does not exist
  def UserToken.refresh(user_id, key)
    user = User.find(user_id)
    $redis.expire(UserToken.digest(key, user.email), ACCESS_TOKEN_EXPIRE)
  end

  # Hash the key
  #
  # @param [String] key
  # @param [String] user_email
  #
  # @return [String] digest of the key
  def UserToken.digest(key, user_email)
    Digest::SHA512.hexdigest(key+HASH_SALT+user_email)
  end

  private

    attr_writer :user_id, :key, :expire_in
    attr_accessor :user_email

    validates :user_id, presence: true
    validates :key, presence: true
    validates :expire_in, presence: true
    validates :user_email, presence: true

end
