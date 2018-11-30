class UserTokensController < ApplicationController

  def create
    @errors = []
    if !validate_credential_params(params, @errors)
      render json: { errors: @errors }, status: :bad_request
    else
      user = User.find_by(email: params[:credential][:email].downcase)
      if user && user.authenticate(params[:credential][:password])
        @user_token = UserToken.new(user)
        @user_token.save
        render json: { user_token: @user_token }, status: :created
      else
        @errors = [ Error.new("invalid_credential") ]
        render json: { errors: @errors }, status: :bad_request
      end
    end
  end

  private

    # Strong parameter of model UserToken
    def credential_params
      params.require(:credential).permit(:email, :password)
    end

    def validate_credential_params(params, errors=[])
      if credential_params[:email] && credential_params[:password]
        return true
      else
        if !credential_params[:email]
          error = Error.new("missing_field", "credential:email")
          errors << error
        end
        if !credential_params[:password]
          error = Error.new("missing_field", "credential:password")
          errors << error
        end
        return false
      end
    rescue ActionController::ParameterMissing => e
      error = Error.new("missing_field", "credential")
      errors << error
      return false
    end

end
