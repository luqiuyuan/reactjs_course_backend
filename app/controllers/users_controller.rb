class UsersController < ApplicationController

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: { user: @user }, status: :created
    else
      @errors = translateModelErrors @user
      add_prefix_to_field @errors, "user:"
      render json: { errors: @errors }, status: :bad_request
    end
  rescue ActionController::ParameterMissing
    @errors = [Error.new('missing_field', 'user')]
    render json: { errors: @errors }, status: :bad_request
  end

  private

    # Strong parameter of model User
    def user_params
      params.require(:user).permit(:email, :password, :name, :avatar_url, :description)
    end

end
