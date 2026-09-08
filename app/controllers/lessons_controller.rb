class LessonsController < ApplicationController
  before_action :authenticate_user! # Wajib login
  before_action :require_dosen!, only: %i[ new create edit update destroy ]
  before_action :set_lesson, only: %i[ show edit update destroy ]

  # GET /lessons or /lessons.json
  def index
    @lessons = Lesson.all
  end

  # GET /lessons/1 or /lessons/1.json
  def show
  end

  # GET /lessons/new
  def new
    @lesson = Lesson.new
  end

  # GET /lessons/1/edit
  def edit
  end

  # POST /lessons or /lessons.json
  def create
    @lesson = Lesson.new(lesson_params)

    respond_to do |format|
      if @lesson.save
        format.html { redirect_to @lesson, notice: "Lesson was successfully created." }
        format.json { render :show, status: :created, location: @lesson }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @lesson.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /lessons/1 or /lessons/1.json
  def update
    respond_to do |format|
      if @lesson.update(lesson_params)
        format.html { redirect_to @lesson, notice: "Lesson was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @lesson }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @lesson.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /lessons/1 or /lessons/1.json
  def destroy
    @lesson.destroy!

    respond_to do |format|
      format.html { redirect_to lessons_path, notice: "Lesson was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def submit_quiz
    @lesson = Lesson.find(params[:id])

    # Keamanan 1: Tolak jika sudah pernah mengerjakan
    if @lesson.submissions.exists?(user: current_user)
      redirect_to @lesson, alert: "Anda sudah mengerjakan kuis ini. Tidak dapat diulang!"
      return
    end

    # Menghitung Nilai
    correct_answers = 0
    total_questions = @lesson.questions.count

    if total_questions > 0 && params[:answers].present?
      params[:answers].each do |question_id, selected_option|
        question = Question.find(question_id)
        if question.correct_answer == selected_option
          correct_answers += 1
        end
      end

      # Rumus persentase nilai (Benar / Total Soal * 100)
      score = (correct_answers.to_f / total_questions) * 100
    else
      score = 0
    end

    # Simpan ke database secara permanen
    Submission.create(user: current_user, lesson: @lesson, score: score)

    redirect_to @lesson, notice: "Kuis berhasil diselesaikan! Nilai Anda: #{score.to_i}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lesson
      @lesson = Lesson.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def lesson_params
      params.expect(lesson: [ :topic_id, :title, :content, :compiler_url, :hackerrank_url ])
    end
end
