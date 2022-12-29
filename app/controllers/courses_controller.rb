class CoursesController < ApplicationController
  include VersioningHelper

  load_and_authorize_resource except: %i[export_courses_json show revert_to]
  skip_authorization_check only: :export_courses_json
  skip_before_action :authenticate_user!, only: :export_courses_json
  
  before_action :set_course, only: %i[edit update destroy export_course_json revert_to]
  before_action :set_current_as_of_time, :set_existing_semesters, only: %i[index show]
  before_action :set_current_semester, only: %i[index export_courses_json]
  before_action :set_current_semester_in_show, only: %i[show]
  helper_method :is_deleted_course?

  # GET /courses
  # GET /courses.json
  def index
    if params[:commit] == "Reset"
      redirect_to courses_path
    end
    if is_latest_version
      @courses = Course.order_valid_at(@current_semester, :name)
    else
      @courses = Course.order_valid_at_as_of(@current_semester, @current_as_of_time, :name)
    end
  end

  def versions
    @versions = @course.versions
    @programs = @course.programs.order(:name)
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    # Authorize needs to be done here to be able to show deleted courses,
    # which cancancan wont be able to find automatically using just the id in 'load_and_authorize_resource'
    authorize! :show, Course

    id = params[:id]
    split = split_to_id_and_valid_end(id)

    if is_selected_different_semester(split[1])
      return redirect_to course_path("#{split[0]},#{@current_semester}",:as_of_time => params[:as_of_time])
    end


    if is_latest_version && !is_deleted_course?(id)
      set_course
    else
      unless set_course_for_as_of_time
        if is_deleted_course?(id)
          return redirect_to courses_path, notice: "Course does not exist at that time"
        else # not deleted, can show current version instead
          return redirect_to course_path(id), notice: "Course does not exist at that time"
        end
      end
    end

    if params[:commit] == "Reset"
      return redirect_to course_path(@course)
    end

    @programs = @course.programs.order(:name)
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
    filename = "#{helpers.generate_filename(@course)}_#{get_semester_name(@course.valid_end)}"
    send_data data, type: 'application/json; header=present',
                    disposition: "attachment; filename=#{filename}.json"
  end

  def export_courses_json
    courses = Course.where(valid_end: @current_semester)
    data = []
    courses.each do |course|
      data << course.gather_data_for_json_export
    end
    data = JSON.pretty_generate(data)
    data = data.as_json
    filename = "#{Date.today}_all-courses_#{get_semester_name(@current_semester)}"
    send_data data, type: 'application/json; header=present',
                    disposition: "attachment; filename=#{filename}.json"
  end

  def export_course_docx
    base_url = ENV['EXPORTER_BASE_URL'] || 'http://localhost:3030/'
    post_url = base_url + 'docx/course'
    course = Course.find_by(id: params[:id])
    course_json = course.gather_data_for_json_export.to_json

    logger.debug course_json
    begin
      resp = Faraday.post(post_url, course_json, 'Content-Type' => 'application/json')
      logger.debug resp
      filename = "#{helpers.generate_filename(course)}_#{get_semester_name(course.valid_end)}"
      send_data resp.body, filename: filename + '.docx'
    rescue Faraday::ConnectionFailed => e
      redirect_to courses_path, alert: 'Error: Course could not be exported as DOCX because the connection to the external export service failed!'
    end
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

    unless @course.save # Save first to generate id of course, to be used when creating link
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @course.errors, status: :unprocessable_entity }
    end

    create_course_program_link(@course, params[:program_id])

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_course_program_link(_course, program_id)
    if program_id.nil?
      @course_program = nil
      return
    end
    split = split_to_id_and_valid_end(program_id)
    @course_program = @course.course_programs.build(program_id: split[0], program_valid_end: split[1])
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def revert_to
    authorize! :update, @course

    if @course.revert(params[:id], params[:transaction_start])
      respond_to do |format|
        format.html { redirect_to @course, notice: 'Course was successfully reverted.' }
        format.json { render :show, status: :ok, location: @course }
      end
    else
      respond_to do |format|
        format.html { render versions }
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

  def set_course_for_as_of_time
    @course = Course.find_as_of(@current_as_of_time, params[:id])
    !@course.nil?
  end

  def is_deleted_course?(id)
    split = split_to_id_and_valid_end(id)
    !Course.exists?(id: split[0], valid_end: split[1])
  end

  def set_existing_semesters
    id = params[:id]
    if !id
      @existing_semesters = Course.order(:valid_end).distinct.pluck(:valid_end)
    else
      split = split_to_id_and_valid_end(id)
      @existing_semesters = Course.where(id: split[0]).order(:valid_end).distinct.pluck(:valid_end)
    end
  end


  # Only allow a list of trusted parameters through.
  def course_params
    params.require(:course).permit(:name, :code, :mission, :ects, :examination, :objectives, :contents,
                                   :prerequisites, :literature, :methods, :skills_knowledge_understanding,
                                   :skills_intellectual, :skills_practical, :skills_general,
                                   :lectureHrs, :labHrs, :tutorialHrs, :equipment, :room, :responsible_person, :comment,
                                   :semester_season,  :semester_year)
  end
end
