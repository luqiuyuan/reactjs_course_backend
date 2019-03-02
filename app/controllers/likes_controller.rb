class LikesController < ApplicationController

  before_action :authenticate_user_token, only: [:create, :destroy]
  before_action :set_user_logged_in, only: [:create, :destroy]
  before_action :set_likable, only: [:create, :destroy]

  # POST /questions/:question_id/like
  def create
    @like = Like.new(user: @user_logged_in, likable: @likable)
    if @like.save
      render json: { like: @like }, status: :created
    else
      @errors = translateModelErrors @like
      add_prefix_to_field @errors, "like:"
      render json: { errors: @errors }, status: :bad_request
    end
  end

  # DELETE /questions/:question_id/like
  def destroy
    @like = Like.find_by!(user: @user_logged_in, likable: @likable)

    @like.destroy

    render json: { like: @like }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render status: :not_found
  end

  private

    def set_likable
      if likable_type == 'questions'
        @likable = Question.find(params[:question_id])
      else likable_type == 'answers'
        @likable = Answer.find(params[:answer_id])
      end
    rescue ActiveRecord::RecordNotFound
      render status: :not_found
    end

    def likable_type
      uri = request.env['PATH_INFO']
      resource = uri.split('/')[1]
      return resource
    end

end
