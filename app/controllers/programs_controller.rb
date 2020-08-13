class ProgramsController < ApplicationController
  before_action :set_program, only: [:show, :edit, :update, :destroy, :export_program_json]

  # GET /programs
  # GET /programs.json
  def index
    @programs = Program.all
  end

  # GET /programs/1
  # GET /programs/1.json
  def show
    @course_programs = @program.course_programs.order(:semester).includes(:course)
  end

  def export_program_json
    data = get_program_data(@program)
    data = JSON.pretty_generate(data)
    code = @program.try(:code) ? @program.code : 'XX'
    name = @program.try(:name) ? @program.name : 'xxx'
    filename = Date.today.to_s + '_' + code.to_s + '-' + name.to_s
    send_data data, type: 'application/json; header=present',
                    disposition: "attachment; filename=#{filename}.json"
  end

  def export_programs_json
    programs = Program.all
    data = [].as_json
    data = JSON.pretty_generate(data)
    programs.each do |program|
      data << get_program_data(program).as_json
    end
    data = data.as_json
    filename = Date.today.to_s
    send_data data, type: 'application/json; header=present',
                    disposition: "attachment; filename=#{filename}_all-programs.json"
  end

  # GET /programs/new
  def new
    @program = Program.new
  end

  # GET /programs/1/edit
  def edit
  end

  # POST /programs
  # POST /programs.json
  def create
    @program = Program.new(program_params)

    respond_to do |format|
      if @program.save
        format.html { redirect_to @program, notice: 'Program was successfully created.' }
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
        format.html { redirect_to @program, notice: 'Program was successfully updated.' }
        format.json { render :show, status: :ok, location: @program }
      else
        format.html { render :edit }
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

    # Only allow a list of trusted parameters through.
    def program_params
      params.require(:program).permit(:name, :code, :mission, :degree, :ects)
    end

    def get_program_data(program)
      data = program.as_json
      course_programs = program.course_programs.order(:semester).includes(:course)
      courses = []
      course_programs.each do |cp|
        courses << Course.find_by(id: cp.course_id).as_json
      end
      data['courses'] = courses
      data = data.as_json
      data
    end
end
