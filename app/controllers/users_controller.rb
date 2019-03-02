class UsersController < ApplicationController

  before_action :authenticate_user_token, only: [:update, :destroy]
  before_action :set_user_logged_in, only: [:show, :update, :destroy]
  before_action :set_user, only: [:show]

  # GET /users
  def index
    @users = User.all
    
    if @users.empty?
      render status: :not_found
    else
      render json: { users: @users }, status: :ok
    end
  end

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
    if @user_logged_in.update(user_params)
      render json: { user: @user_logged_in }, status: :ok
    else
      @errors = translateModelErrors @user_logged_in
      add_prefix_to_field @errors, "user:"
      render json: { errors: @errors }, status: :bad_request
    end
  end

  # DELETE
  def destroy
    @user_logged_in.destroy
    render json: { user: @user_logged_in }, status: :ok
  end

  private

    # Strong parameter of model User
    def user_params
      params.require(:user).permit(:email, :password, :name, :avatar_url, :description)
    end

    # Setup @user from parameter id
    def set_user
      uri = request.env['PATH_INFO']
      resource = uri.split('/')[1]

      if resource == 'user' and !@user_logged_in.blank?
        @user = @user_logged_in
      else
        @user = User.find(params[:id])
      end
    rescue ActiveRecord::RecordNotFound
      render status: :not_found
    end

end
