class LikesController < ApplicationController

  before_action :set_question, only: [:create, :destroy]
  before_action :set_like, only: [:create, :destroy]

  # POST /questions/:question_id/like
  def create
    @like = Like.new()

    # if @like.save
    #   render json: @like, status: :created, location: @like
    # else
    #   render json: @like.errors, status: :unprocessable_entity
    # end
  end

  # DELETE /questions/:question_id/like
  def destroy
    # @like.destroy
  end

end
