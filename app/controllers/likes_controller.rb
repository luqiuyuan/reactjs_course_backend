class LikesController < ApplicationController

  before_action :set_user_logged_in, only: [:create, :destroy]
  before_action :set_question, only: [:create, :destroy]

  # POST /questions/:question_id/like
  def create
    @like = Like.new(user: @user_logged_in, likable: @question)
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
    @like = Like.find_by(user: @user_logged_in, likable: @question)
  rescue ActiveRecord::RecordNotFound
    render status: :not_found
  end

  private

    def set_question
      @question = Question.find(params[:question_id])
    rescue ActiveRecord::RecordNotFound
      render status: :not_found
    end

end
