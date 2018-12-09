class AuthenticationTestingController < ApplicationController

  before_action :authenticate_user_token, only: [:authenticate]

  def authenticate
  	render status: :ok
  end

end
