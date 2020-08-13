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
      data = JSON.parse(file.read) #, symbolize_names: true)
      # helper? -> create_course_from_json oder so
      course = Course.new
      course.name = data['name']
      course.code = data['code']
      course.mission = data['mission']
      course.ects = data['ects']
      course.examination = data['examination']
      course.objectives = data['objectives']
      course.contents = data['contents']
      course.prerequisites = data['prerequisites']
      course.literature = data['literature']
      course.methods = data['methods']
      course.skills_knowledge_understanding = data['skills_knowledge_understanding']
      course.skills_intellectual = data['skills_intellectual']
      course.skills_practical = data['skills_practical']
      course.skills_general = data['skills_general']
      course.lectureHrs = data['lectureHrs']
      course.labHrs = data['labHrs']
      course.tutorialHrs = data['tutorialHrs']
      course.equipment = data['equipment']
      course.room = data['room']
      course.save
      @course = course
      create_course_program_link(course, params[:program_id]) if params[:program_id]
      course.save
      # else
      #   programs = data['programs']
      #   programs.each do |program|
      #     #{"id"=>1, "name"=>"Internationale Medieninformatik", "code"=>"IMI-B", "mission"=>nil, "degree"=>"Bachelor", "ects"=>180, "created_at"=>"2020-08-10T12:53:42.070Z", "updated_at"=>"2020-08-10T12:53:42.070Z"}
      #     #course_program = CourseProgram.new
      #     #course_program. ...
      #     #course_program.save
      #     # TODO: finish concept!!!
      #   end
      # end
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
      data << get_course_data(course).as_json
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
