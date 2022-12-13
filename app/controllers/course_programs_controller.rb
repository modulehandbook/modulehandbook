class CourseProgramsController < ApplicationController
  include VersioningHelper

  load_and_authorize_resource
  before_action :set_course_program, only: %i[show edit update destroy]
  before_action :set_existing_semesters, only: %i[index]
  before_action :set_current_semester, only: %i[index]

  # GET /course_programs
  # GET /course_programs.json
  def index
    @course_programs = if params[:program_id]
                         CourseProgram.where(program_id: params[:program_id], program_valid_end: @current_semester)
                                      .includes(:program, :course)
                                      .order('programs.name', 'semester', 'courses.name')
                       else
                         CourseProgram.where(program_valid_end: @current_semester)
                                      .includes(:course, :program)
                                      .order('programs.name', 'semester', 'courses.name')
                       end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @course_programs }
    end
  end

  # GET /course_programs/1
  # GET /course_programs/1.json
  def show; end

  # GET /course_programs/new
  def new
    @course_program = CourseProgram.new
  end

  # GET /course_programs/1/edit
  def edit; end

  # POST /course_programs
  # POST /course_programs.json
  def create
    @course_program = CourseProgram.new(course_program_params)
    next_view_edit = params['next_view'] && params['next_view'] == 'edit'
    respond_to do |format|
      if @course_program.save && !next_view_edit
        format.html { redirect_to @course_program, notice: 'Course program was successfully created.' }
        format.json { render :show, status: :created, location: @course_program }
      else
        format.html { render :new, status: :unprocessable_entity }
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
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course_program.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /course_programs/1
  # DELETE /course_programs/1.json
  def destroy
    @program = @course_program.program
    @course_program.destroy
    respond_to do |format|
      format.html { redirect_to @program, notice: 'Course program was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_course_program
    @course_program = CourseProgram.includes(:course, :program).find(params[:id])
  end

  def set_existing_semesters
      @existing_semesters = []
      @existing_semesters = @existing_semesters + Program.distinct.pluck(:valid_end)
      @existing_semesters = @existing_semesters + Course.distinct.pluck(:valid_end)
  end

  # Only allow a list of trusted parameters through.
  # + split id to extract valid_end if required
  def course_program_params
    formatted_params = params.require(:course_program).permit(:course_id, :program_id, :course_valid_end, :program_valid_end, :semester, :required)

    unless formatted_params.key?(:course_valid_end)
      split = split_to_id_and_valid_end(formatted_params[:course_id])
      formatted_params[:course_id] = split[0]
      formatted_params[:course_valid_end] = split[1]
    end

    unless formatted_params.key?(:program_valid_end)
      split = split_to_id_and_valid_end(formatted_params[:program_id])
      formatted_params[:program_id] = split[0]
      formatted_params[:program_valid_end] = split[1]
    end

    formatted_params
  end
end
