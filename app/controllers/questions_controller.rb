class QuestionsController < ApplicationController

  before_action :authenticate_user_token, only: [:create, :update, :destroy]
  before_action :set_user_logged_in, only: [:create, :update, :destroy]
  before_action :set_question, only: [:show, :update, :destroy]
  before_action :validate_access, only: [:update, :destroy]

  # GET /questions
  def index
    @questions = Question.all.order(created_at: :desc)

    if !@questions.empty?
      render json: { questions: view_index(@questions) }, status: :ok
    else
      render status: :not_found
    end
  end

  # GET /questions/:id
  def show
    render json: { question: view_show(@question) }, status: :ok
  end

  # POST /questions
  def create
    @question = Question.new(question_params)
    @question.user = @user_logged_in
    if @question.save
      render json: { question: view_show(@question) }, status: :created
    else
      @errors = translateModelErrors @question
      add_prefix_to_field @errors, "question:"
      render json: { errors: @errors }, status: :bad_request
    end
  rescue ActionController::ParameterMissing
    @errors = [Error.new('missing_field', 'question')]
    render json: { errors: @errors }, status: :bad_request
  end

  # PATCH/PUT /questions/:id
  def update
    if @question.update(question_params)
      render json: { question: view_show(@question) }, status: :ok
    else
      @errors = translateModelErrors @question
      add_prefix_to_field @errors, "question:"
      render json: { errors: @errors }, status: :bad_request
    end
  end

  # DELETE /questions/:id
  def destroy
    @question.destroy
    render json: { question: view_show(@question) }, status: :ok
  end

  private

    # Strong parameter of model Question
    def question_params
      params.require(:question).permit(:title, :content)
    end

    def set_question
      @question = Question.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render status: :not_found
    end

    # Check if the logged-in user has access to the question
    def validate_access
      if @user_logged_in != @question.user
        render status: :forbidden
      end
    end

    def view_index(questions)
      questions_view = []
      questions.each do |question|
        questions_view.push({
          id: question.id,
          title: question.title,
          content: question.content,
          user_id: question.user_id,
          created_at: question.created_at,
          updated_at: question.updated_at,
          number_of_likes: question.likes.size
        })
      end
      return questions_view
    end

    def view_show(question)
      return {
        id: question.id,
        title: question.title,
        content: question.content,
        user_id: question.user_id,
        created_at: question.created_at,
        updated_at: question.updated_at,
        number_of_likes: question.likes.size
      }
    end

end
