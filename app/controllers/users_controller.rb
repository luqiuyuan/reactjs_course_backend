class UsersController < ApplicationController

  before_action :set_user, only: [:show, :update]

  # GET /users/:id
  def show
    render json: { user: @user }, status: :ok
  end

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

  # PATCH /users/:id
  # PUT /users/:id
  def update
    if @user.update(user_params)
      render json: { user: @user }, status: :ok
    else
      @errors = translateModelErrors @user
      add_prefix_to_field @errors, "user:"
      render json: { errors: @errors }, status: :bad_request
    end
  end

  private

    # Strong parameter of model User
    def user_params
      params.require(:user).permit(:email, :password, :name, :avatar_url, :description)
    end

    # Setup @user from parameter id
    def set_user
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render status: :not_found
    end

end
