class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy, :export_course_json]

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

  def import_course_json
    files = params[:files] || []
    files.each do |file|
      data = JSON.parse(file.read)
      @course = Course.create_from_json(data)
      create_course_program_link(@course, params[:program_id]) if params[:program_id]
      @course.save
      # TODO: Programs erstellen lassen?
      programs = data['programs']
      programs.each do |program_data|
        program = Program.create_from_json(program_data)
        create_course_program_link(@course, program.id)
        @course.save
      end
    end
    respond_to do |format|
      if files.count < 1
        format.html { redirect_to courses_path }
      elsif files.count > 1 && params[:program_id]
        format.html { redirect_to program_path(params[:program_id]) }
      elsif files.count > 1
        format.html { redirect_to courses_path }
      else
        format.html { redirect_to course_path(@course) }
      end
    end
  end

  def export_course_json
    data = get_course_data(@course).as_json
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
      data << get_course_data(course).to_json
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

    def get_course_data(course)
      data = course.as_json
      programs = course.programs.order(:name).as_json
      data['programs'] = programs
      data = data.as_json
      data
    end
end
