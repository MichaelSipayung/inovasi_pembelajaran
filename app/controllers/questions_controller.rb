class QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_dosen!
  before_action :set_lesson
  before_action :set_question, only: %i[ edit update destroy ]

  def new
    @question = @lesson.questions.build
  end

  def create
    @question = @lesson.questions.build(question_params)
    if @question.save
      redirect_to @lesson, notice: "Soal kuis berhasil ditambahkan."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to @lesson, notice: "Soal kuis berhasil diperbarui."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
    redirect_to @lesson, notice: "Soal kuis berhasil dihapus.", status: :see_other
  end

  private

  def set_lesson
    @lesson = Lesson.find(params[:lesson_id])
  end

  def set_question
    @question = @lesson.questions.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:content, :option_a, :option_b, :option_c, :option_d, :correct_answer)
  end
end
