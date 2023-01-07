class ProgramsController < ApplicationController
  include VersioningHelper

  load_and_authorize_resource except: %i[export_courses_json show revert_to]
  skip_authorization_check only: :export_programs_json
  skip_before_action :authenticate_user!, only: :export_programs_json


  before_action :set_program, only: %i[edit update destroy export_program_json revert_to]
  before_action :set_current_as_of_time, :set_existing_semesters, only: %i[index show]
  before_action :set_current_semester, only: %i[index export_programs_json]
  before_action :set_current_semester_in_show, only: %i[show]
  helper_method :is_deleted_program?

  # GET /programs
  # GET /programs.json
  def index
    if params[:commit] == "Reset"
      redirect_to programs_path
    end

    if is_latest_version
      @programs = Program.order_valid_at(@current_semester,:name)
    else
      @programs = Program.order_valid_at_as_of(@current_semester,@current_as_of_time, :name)
    end
  end

  def versions
    @versions = @program.versions
  end

  # GET /programs/1
  # GET /programs/1.json
  def show
    # Authorize needs to be done here to be able to show deleted programs,
    # which cancancan wont be able to find automatically using just the id in 'load_and_authorize_resource'
    authorize! :show, Program

    id = params[:id]
    split = split_to_id_and_valid_end(id)

    if is_selected_different_semester(split[1])
      return redirect_to program_path("#{split[0]},#{@current_semester}",:as_of_time => params[:as_of_time])
    end

    if is_latest_version && !is_deleted_program?(id)
      @program = Program.find(id)
    else
      unless set_program_for_as_of_time
        if is_deleted_program?(id)
          return redirect_to programs_path, notice: "Program does not exist at that time"
        else
          return redirect_to program_path(id), notice: "Program does not exist at that time"
        end
      end
    end

    if params[:commit] == "Reset"
      return redirect_to program_path(@program)
    end

    @course_programs = @program
                       .course_programs
                       .includes(:course)
                       .order('required DESC', 'semester', 'courses.name')
  end

  def overview
    @course_programs = @program.course_programs.includes(:course)
    @rows = @program.course_programs.includes(:course).order('course_programs.semester', 'courses.code').group_by(&:semester)
  end

  def import_program_json
    files = params[:files] || []
    files.each do |file|
      @program = Program.json_import_from_file(file)
    end
    respond_to do |format|
      if files.count < 1
        format.html { redirect_to programs_path, notice: 'No files selected to import Program(s) from' }
      end
      format.html { redirect_to programs_path, notice: 'Programs successfully imported' } if files.count > 1
      format.html { redirect_to program_path(@program), notice: 'Program successfully imported' } if files.count == 1
    end
  end

  def export_program_json
    data = @program.gather_data_for_json_export
    data = JSON.pretty_generate(data)
    filename = "#{helpers.generate_filename(@program)}_#{get_semester_name(@program.valid_end)}"
    send_data data, type: 'application/json; header=present',
                    disposition: "attachment; filename=#{filename}.json"
  end

  def export_programs_json
    programs = Program.all
    data = []
    programs.each do |program|
      data << program.gather_data_for_json_export
    end
    data = JSON.pretty_generate(data)
    data = data.as_json
    filename = "#{Date.today}_all-programs_#{get_semester_name(@current_semester)}"
    send_data data, type: 'application/json; header=present',
                    disposition: "attachment; filename=#{filename}.json"
  end

  def export_program_docx
    base_url = ENV['EXPORTER_BASE_URL'] || 'http://localhost:3030/'
    post_url = base_url + 'docx/program'
    program = Program.find_by(id: params[:id])
    program_json = program.gather_data_for_json_export.to_json

    logger.debug program_json
    begin
      resp = Faraday.post(post_url, program_json, 'Content-Type' => 'application/json')
      logger.debug resp
      filename = "#{helpers.generate_filename(program)}_#{get_semester_name(program.valid_end)}"
      send_data resp.body, filename: filename + '.docx'
    rescue Faraday::ConnectionFailed => e
      redirect_to programs_path, alert: 'Error: Program could not be exported as DOCX because the connection to the external export service failed!' + post_url
    end
  end

  # GET /programs/new
  def new
    @program = Program.new
  end

  # GET /programs/1/edit
  def edit; end

  # POST /programs
  # POST /programs.json
  def create
    @program = Program.new(program_params)

    respond_to do |format|
      if @program.save
        format.html { redirect_to @program, notice: 'Program was successfully created.' }
        format.json { render :show, status: :created, location: @program }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /programs/1
  # PATCH/PUT /programs/1.json
  def update
    respond_to do |format|
      if @program.update(program_params)
        format.html { redirect_to @program, notice: 'Program was successfully updated.' }
        format.json { render :show, status: :ok, location: @program }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  def revert_to
    authorize! :update, @program

    if @program.revert(params[:id], params[:transaction_start])
      respond_to do |format|
        format.html { redirect_to @program, notice: 'Program was successfully reverted.' }
        format.json { render :show, status: :ok, location: @program }
      end
    else
      respond_to do |format|
        format.html { render versions, status: :unprocessable_entity }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /programs/1
  # DELETE /programs/1.json
  def destroy
    @program.destroy
    respond_to do |format|
      format.html { redirect_to programs_url, notice: 'Program was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_program
    @program = Program.find(params[:id])
  end

  def set_program_for_as_of_time
    @program = Program.find_as_of(@current_as_of_time, params[:id])
    !@program.nil?
  end

  def is_deleted_program?(id)
    split = split_to_id_and_valid_end(id)
    !Program.exists?(id: split[0], valid_end: split[1])
  end

  def set_existing_semesters
    id = params[:id]
    if !id
      @existing_semesters = Program.order(:valid_end).distinct.pluck(:valid_end)
    else
      split = split_to_id_and_valid_end(id)
      @existing_semesters = Program.where(id: split[0]).order(:valid_end).distinct.pluck(:valid_end)
    end
  end

  # Only allow a list of trusted parameters through.
  def program_params
    params.require(:program).permit(:name, :code, :mission, :degree, :ects, :semester_season,  :semester_year)
  end
end
