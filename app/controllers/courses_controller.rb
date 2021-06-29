class CoursesController < ApplicationController
  load_and_authorize_resource
  before_action :set_course, only: %i[show edit update destroy export_course_json]
  before_action :set_paper_trail_whodunnit

  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.order(:name)
  end

  def versions
    @versions = @course.versions.order(:created_at)
    @programs = @course.programs.order(:name).pluck(:name, :id)
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @programs = @course.programs.order(:name).pluck(:name, :id)
    @course_program = CourseProgram.new(course: @course)
    @comments_size = @course.comments.size
    @comments = @course.comments
    @comment = @course.comments.build(author: @current_user)
  end

  def import_course_json
    files = params[:files] || []
    files.each do |file|
      @course = Course.json_import_from_file(file, params[:program_id])
    end
    respond_to do |format|
      if files.count < 1
        format.html { redirect_to courses_path, notice: 'No files selected to import Course(s) from' }
      elsif files.count > 1 && params[:program_id]
        format.html { redirect_to program_path(params[:program_id]), notice: 'Course successfully imported into this Program' }
      elsif files.count > 1
        format.html { redirect_to courses_path, notice: 'Courses successfully imported' }
      else
        format.html { redirect_to course_path(@course), notice: 'Course successfully imported' }
      end
    end
  end

  def export_course_json
    data = @course.gather_data_for_json_export.as_json
    data = JSON.pretty_generate(data)
    code = @course.try(:code) ? @course.code.gsub(' ', '') : 'XX'
    name = @course.try(:name) ? @course.name.gsub(' ', '') : 'xxx'
    filename = Date.today.to_s + '_' + code.to_s + '-' + name.to_s
    send_data data, type: 'application/json; header=present',
                    disposition: "attachment; filename=#{filename}.json"
  end

  def export_courses_json
    courses = Course.all
    data = [].as_json
    data = JSON.pretty_generate(data)
    courses.each do |course|
      data << course.gather_data_for_json_export.to_json
    end
    data = data.as_json
    filename = Date.today.to_s
    send_data data, type: 'application/json; header=present',
                    disposition: "attachment; filename=#{filename}_all-courses.json"
  end

  # GET /courses/new
  def new
    @course = Course.new
    @program = Program.find(params[:program_id]) unless params['program_id'].nil?
  end

  # GET /courses/1/edit
  def edit; end

  def change_state
    @course = Course.find(params[:course_id])
    event = params[:event_name] + '!'
    @course.send(event.to_sym)
    redirect_to course_path(@course), notice: 'State updated'
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)
    create_course_program_link(@course, params[:program_id])
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

  def create_course_program_link(_course, program_id)
    @course_program = @course.course_programs.build(program_id: program_id) unless program_id.nil?
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
                                   :lectureHrs, :labHrs, :tutorialHrs, :equipment, :room, :responsible_person, :comment)
  end
end
