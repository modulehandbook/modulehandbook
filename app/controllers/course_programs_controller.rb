class CourseProgramsController < ApplicationController
  before_action :set_course_program, only: [:show, :edit, :update, :destroy]

  # GET /course_programs
  # GET /course_programs.json
  def index
    @course_programs = CourseProgram.all
  end

  # GET /course_programs/1
  # GET /course_programs/1.json
  def show
  end

  # GET /course_programs/new
  def new
    @course_program = CourseProgram.new
  end

  # GET /course_programs/1/edit
  def edit
  end

  # POST /course_programs
  # POST /course_programs.json
  def create
    @course_program = CourseProgram.new(course_program_params)

    respond_to do |format|
      if @course_program.save
        format.html { redirect_to @course_program, notice: 'Course program was successfully created.' }
        format.json { render :show, status: :created, location: @course_program }
      else
        format.html { render :new }
        format.json { render json: @course_program.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /course_programs/1
  # PATCH/PUT /course_programs/1.json
  def update
    respond_to do |format|
      if @course_program.update(course_program_params)
        format.html { redirect_to @course_program, notice: 'Course program was successfully updated.' }
        format.json { render :show, status: :ok, location: @course_program }
      else
        format.html { render :edit }
        format.json { render json: @course_program.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /course_programs/1
  # DELETE /course_programs/1.json
  def destroy
    @course_program.destroy
    respond_to do |format|
      format.html { redirect_to course_programs_url, notice: 'Course program was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_program
      @course_program = CourseProgram.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_program_params
      params.require(:course_program).permit(:course_id, :program_id, :semester, :required)
    end
end
