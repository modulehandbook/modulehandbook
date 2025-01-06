# frozen_string_literal: true

class CoursesController < ApplicationController
  include ApplicationHelper

  load_and_authorize_resource except: :export_courses_json
  skip_authorization_check only: :export_courses_json
  skip_before_action :authenticate_user!, only: :export_courses_json

  before_action :set_course, only: %i[show edit update destroy export_course_json revert_to]
  before_action :set_paper_trail_whodunnit
  include VersionsHelper
  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.order(:name)
    @courses = @courses.sort do |c1, c2|
      compare_course_codes(c1.code, c2.code)
    end
  end

  def versions
    @versions = @course.versions.reorder('created_at DESC')
    @versions_authors = @versions.map { |v| [v, papertrail_author(v)] }
    @programs = @course.programs.order(:name).pluck(:name, :id)
  end

  LinkMemo = Data.define(:program, :link, :text)

  # GET /courses/1
  # GET /courses/1.json
  def show
    @tab = (params['tab'] || :course).to_sym
    @links = @course.course_programs.includes(:program)
    @link_memos = @links.map do |l|
      LinkMemo.new(l.program, l,
                   "#{l.semester}. Sem. / #{l.required}")
    end
    @link_memos = @link_memos.sort { |a, b| a.program.name <=> b.program.name }
    @programs = @course.programs.order(:name).pluck(:name, :id)

    @course_program = CourseProgram.new(course: @course)
    @comments = @course.comments
    @comments_size = @comments.size
    @comment = @course.comments.build(author: @current_user)
    if @tab == :topics
      @topic_descriptions = @course.topic_descriptions
    end
  end

  def import_course_json
    files = params[:files] || []
    import_with_program_context = params.has_key?(:program_id)
    program_context = import_with_program_context ? params[:program_id] : :no_program_id
    files.each do |file|
      @course = Course.json_import_from_file(file, program_context)
    end
    respond_to do |format|
      if files.count < 1
        format.html { redirect_to courses_path, notice: I18n.t('controllers.courses.error_import') }
      elsif files.count > 1 && import_with_program_context
        format.html do
          redirect_to program_path(program_context), notice: I18n.t('controllers.courses.imported_to_program')
        end
      elsif files.count > 1
        format.html { redirect_to courses_path, notice: I18n.t('controllers.courses.many_imported') }
      else
        format.html { redirect_to course_path(@course), notice: I18n.t('controllers.courses.imported') }
      end
    end
  end

  def export_course_json
    data = @course.gather_data_for_json_export.as_json
    data = JSON.pretty_generate(data)
    code = @course.try(:code) ? @course.code.gsub(' ', '') : 'XX'
    name = @course.try(:name) ? @course.name.gsub(' ', '') : 'xxx'
    filename = "#{Time.zone.today}_#{code}-#{name}"
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
    filename = Time.zone.today.to_s
    send_data data, type: 'application/json; header=present',
                    disposition: "attachment; filename=#{filename}_all-courses.json"
  end

  def export_course_docx
    base_url = ENV['EXPORTER_BASE_URL'] || 'http://localhost:3030/'
    post_url = "#{base_url}docx/course"
    course = Course.find_by(id: params[:id])
    course_json = course.gather_data_for_json_export.to_json

    logger.debug course_json
    begin
      resp = Faraday.post(post_url, course_json, 'Content-Type' => 'application/json')
      logger.debug resp
      filename = helpers.generate_filename(course)
      send_data resp.body, filename: filename + '.docx'
    rescue Faraday::ConnectionFailed
      redirect_to courses_path, alert: I18n.t('controllers.courses.error_export')
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
    event_name = params[:event_name]
    @course.accept_event(event_name)
    redirect_to course_path(@course), notice: I18n.t('controllers.courses.state_updated')
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)
    create_course_program_link(@course, params[:program_id])
    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: I18n.t('controllers.courses.created') }
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
        format.html { redirect_to @course, notice: I18n.t('controllers.courses.updated') }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity  }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def revert_to
    @course = @course.versions.find(params[:to_version]).reify
    if @course.save!
      respond_to do |format|
        format.html { redirect_to @course, notice: I18n.t('controllers.courses.reverted') }
        format.json { render :show, status: :ok, location: @course }
      end
    else
      respond_to do |format|
        format.html { render versions(@course) }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: I18n.t('controllers.courses.destroyed') }
      format.json { head :no_content }
    end
  end

  PERMITTED_PARAMS = %i[name code mission ects examination objectives contents
                        prerequisites literature methods skills_knowledge_understanding
                        skills_intellectual skills_practical skills_general
                        lectureHrs labHrs tutorialHrs equipment room responsible_person
                        teacher comment event_name].freeze
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.find(params[:id])
  end


  # Only allow a list of trusted parameters through.
  def course_params
    params.require(:course).permit(PERMITTED_PARAMS)
  end
end
