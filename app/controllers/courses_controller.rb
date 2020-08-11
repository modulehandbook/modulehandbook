class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy, :course_json]

  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.order(:code)
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @programs = @course.programs.order(:name).pluck(:name,:id)
    @course_program = CourseProgram.new(course: @course)
  end

  def course_json
    data = @course.to_json
    code = @course.try(:code) ? @course.code : "XX"
    name = @course.try(:name) ? @course.name : "xxx"
    filename = Date.today.to_s + "_" + code.to_s + "-" + name.to_s
    send_data data, :type => 'application/json; header=present', :disposition => "attachment; filename=#{filename}.json"
  end

  def courses_json
    data = Course.all.to_json
    filename = Date.today.to_s
    send_data data, :type => 'application/json; header=present', :disposition => "attachment; filename=#{filename}_all-courses.json"
  end

  # GET /courses/new
  def new
    @course = Course.new
    @program = Program.find(params[:program_id]) unless params['program_id'].nil?
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)
    create_course_program_link(@course,params[:program_id])
    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_course_program_link(course, program_id)
    unless program_id.nil?
      @course_program = @course.course_programs.build(program_id: program_id)
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:name, :code, :mission, :ects, :examination, :objectives, :contents,
                                     :prerequisites, :literature, :methods, :skills_knowledge_understanding,
                                     :skills_intellectual, :skills_practical, :skills_general,
                                     :lectureHrs,:labHrs, :tutorialHrs, :equipment, :room)
    end
end
