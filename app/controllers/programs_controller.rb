# frozen_string_literal: true

class ProgramsController < ApplicationController
  include ApplicationHelper

  load_and_authorize_resource except: :export_programs_json
  skip_authorization_check only: :export_programs_json
  skip_before_action :authenticate_user!, only: :export_programs_json

  before_action :set_program, only: %i[show edit update destroy export_program_json import_courses_json]
  before_action :set_paper_trail_whodunnit

  # GET /programs
  # GET /programs.json
  def index
    @programs = Program.order(:name)
  end

  # GET /programs/1
  # GET /programs/1.json
  def show

    @tab = (params['tab'] || :program).to_sym
    @course_programs = @program
                       .course_programs
                       .includes(:course)
    # .order('semester',  'courses.code')
    @course_programs = @course_programs.sort do |cp1, cp2|
      compare_course_codes(cp1.course.code, cp2.course.code)
    end
    @show_objectives = params['objectives'] || false
    # .order('semester', 'required DESC', 'courses.code')
    commentable = @program
    @comments = commentable.comments
    @comments_size = @comments.size
    @comment = commentable.comments.build(author: current_user)
    if [:table, :overview].include? @tab
      @semester = overview
    end
    if [:topics, :topics_for_courses].include? @tab
      @topic_descriptions = @program.topic_descriptions
      @topics = @program.topics
      @courses = @course_programs.map{|cp| cp.course}
    end
  end

  def overview
    @course_programs = @program.course_programs.includes(:course)
    @rows = @program.course_programs.study_plan.includes(:course)
                    .order('course_programs.semester', 'courses.code')
                    .group_by(&:semester)
    @elective_rows = @program.course_programs.elective_options.includes(:course)
                             .order('course_programs.semester', 'courses.code')
                             .group_by(&:semester)
    @elective_rows.each do |semester, cps|
      @rows["electives #{semester}"] = cps
    end
    @options = @program.course_programs.where(required: 'elective-option')
    @semester = @rows
    @semester
  end

  def htw_overview
    @course_programs = @program.course_programs.includes(:course)
    @rows = @program.course_programs.study_plan.includes(:course)
                    .order('course_programs.semester', 'courses.code')
                    .group_by(&:semester)
    @elective_rows = @program.course_programs.elective_options.includes(:course)
                             .order('course_programs.semester', 'courses.code')
                             .group_by(&:semester)
    @elective_rows.each do |semester, cps|
      @rows["electives #{semester}"] = cps
    end
    @options = @program.course_programs.where(required: 'elective-option')
    @semester = @rows
  end

  def import_program_json
    files = params[:files] || []
    files.each do |file|
      @program = Program.json_import_from_file(file)
    end
    respond_to do |format|
      if files.count < 1
        format.html { redirect_to programs_path, notice: I18n.t('controllers.programs.program_error_import') }
      end
      if files.count > 1
        format.html do
          redirect_to programs_path, notice: I18n.t('controllers.programs.programs_imported')
        end
      end
      if files.count == 1
        format.html do
          redirect_to program_path(@program), notice: I18n.t('controllers.programs.program_imported')
        end
      end
    end
  end

  def import_courses_json
    files = params[:files] || []
    files.each do |file|
      json = JSON.parse(file.read)
      next unless json.is_a?(Array)

      json.each do |course_json|
        params = ActionController::Parameters.new(course_json).permit(CoursesController::PERMITTED_PARAMS)
        course = @program.courses.find_by(code: params['code'])

        if course
          course.update(params)
        else
          course = @program.courses.create!(params)
        end
        course.save!
        @program.save if @program.changed?
        course_programs = @program.course_programs.where(course_id: course.id)
        course_program = course_programs.first
        course_program_params = ActionController::Parameters.new(course_json).permit(CourseProgramsController::PERMITTED_PARAMS)
        course_program.update(course_program_params)
        course_program.save!
      end
    end
    respond_to do |format|
      if files.count < 1
        format.html { redirect_to program_path(@program), notice: I18n.t('controllers.programs.course_error_import') }
      end
      format.html { redirect_to program_path(@program), notice: I18n.t('controllers.programs.course_imported') }
    end
  end

  def export_program_json
    data = @program.gather_data_for_json_export
    data = JSON.pretty_generate(data)
    filename = helpers.generate_filename(@program)
    send_data data, type: 'application/json; header=present',
                    disposition: "attachment; filename=#{filename}.json"
  end

  def export_programs_json
    programs = Program.all
    data = [].as_json
    data = JSON.pretty_generate(data)
    programs.each do |program|
      data << program.gather_data_for_json_export.to_json
    end
    data = data.as_json
    filename = "#{Time.zone.today}_all_programs"
    send_data data, type: 'application/json; header=present',
                    disposition: "attachment; filename=#{filename}_all-programs.json"
  end

  def export_program_docx
    base_url = ENV['EXPORTER_BASE_URL'] || 'http://localhost:3030/'
    post_url = "#{base_url}docx/program"
    program = Program.find_by(id: params[:id])
    program_json = program.gather_data_for_json_export.to_json

    logger.debug program_json
    begin
      resp = Faraday.post(post_url, program_json, 'Content-Type' => 'application/json')
      logger.debug resp
      filename = helpers.generate_filename(program)
      send_data resp.body, filename: filename + '.docx'
    rescue Faraday::ConnectionFailed
      redirect_to programs_path, alert: I18n.t('controllers.programs.error_export') + post_url
    end
  end

  # GET /programs/new
  def new
    @program = Program.new
  end

  def copy
    @program_copy = @program.create_copy
    @program_copy.save # to save the course list
  end

  # GET /programs/1/edit
  def edit; end

  # POST /programs
  # POST /programs.json
  def create
    @program = Program.new(program_params)

    respond_to do |format|
      if @program.save
        format.html { redirect_to @program, notice: I18n.t('controllers.programs.created') }
        format.json { render :show, status: :created, location: @program }
      else
        format.html { render :new }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /programs/1
  # PATCH/PUT /programs/1.json
  def update
    respond_to do |format|
      if @program.update(program_params)
        format.html { redirect_to @program, notice: I18n.t('controllers.programs.updated') }
        format.json { render :show, status: :ok, location: @program }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /programs/1
  # DELETE /programs/1.json
  def destroy
    @program.destroy
    respond_to do |format|
      format.html { redirect_to programs_url, notice: I18n.t('controllers.programs.destroyed') }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_program
    @program = Program.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  PERMITTED_PARAMS = Program::EDITABLE_ATTRIBUTES
  def program_params
    params.require(:program).permit(PERMITTED_PARAMS)
  end
end
