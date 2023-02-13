class SemestersController < ApplicationController
  include VersioningHelper

  skip_authorization_check
  before_action :set_semesters

  def index
    authorize! :read, Course
    authorize! :read, Program
  end

  def new
    authorize! :edit, Course
    authorize! :edit, Program
    authorize! :edit, CourseProgram
  end

  def generate
    authorize! :edit, Course
    authorize! :edit, Program
    authorize! :edit, CourseProgram

    generate_params = semester_params

    new_season = generate_params[:new_semester_season]
    new_year = generate_params[:new_semester_year]
    new_valid_end = get_valid_end_from_season_and_year(new_season, new_year.to_i)
    new_valid_start = get_valid_start_from_valid_end(new_valid_end)

    copy_season = generate_params[:copy_semester_season]
    copy_year = generate_params[:copy_semester_year]
    copy_valid_end = get_valid_end_from_season_and_year(copy_season, copy_year.to_i)

    unless @existing_semesters.include?(copy_valid_end)
      return redirect_to new_semester_path, notice: "Selected copy semester is not valid"
    end

    copy_semester(copy_valid_end, new_valid_start, new_valid_end)

    respond_to do |format|
      if @errors.empty?
        format.html { redirect_to semesters_path, notice: 'Semester created successfully' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def copy_semester(copy_valid_end, new_valid_start, new_valid_end)
    @errors = []
    programs = Program.where(valid_end: copy_valid_end)
    courses = Course.where(valid_end: copy_valid_end)
    course_programs = CourseProgram.where(program_valid_end: copy_valid_end, course_valid_end: copy_valid_end)

    copy_course_or_programs(Program, programs, new_valid_start, new_valid_end)
    copy_course_or_programs(Course, courses, new_valid_start, new_valid_end)
    copy_course_programs(course_programs, new_valid_end)
  end

  def copy_course_or_programs(class_name, objects, new_valid_start, new_valid_end)
    objects.each do |object|
      attrs = object.attributes.except("transaction_end", "transaction_start", "valid_start", "valid_end")
      if class_name.exists?(id: object[:id], valid_end: new_valid_end)
        update = class_name.update("#{object[:id]},#{new_valid_end}", attrs)
        if update.errors.any?
          @errors.append(update.errors)
        end
      else
        attrs = attrs.merge(valid_start: new_valid_start, valid_end: new_valid_end)
        create = class_name.create(attrs)
        if create.errors.any?
          @errors.append(create.errors)
        end
      end
    end
  end


  def copy_course_programs(course_programs, new_valid_end)
    course_programs.each do |course_program|
      course_program_attrs = course_program.attributes.except("program_valid_end", "course_valid_end", "id")
      existing_attrs = {course_id: course_program.course_id, program_id: course_program.program_id,
                        course_valid_end: new_valid_end, program_valid_end: new_valid_end}

      if CourseProgram.exists?(existing_attrs)
        cp = CourseProgram.find_by(existing_attrs)
        cp.update(course_program_attrs)

        if cp.errors.any?
          @errors.append(update.errors)
        end
      else
        course_program_attrs = course_program_attrs.merge(course_valid_end: new_valid_end, program_valid_end: new_valid_end)
        create = CourseProgram.create(course_program_attrs)
        if create.errors.any?
          @errors.append(create.errors)
        end
      end
    end
  end

  def set_semesters
    @existing_semesters = []
    @existing_semesters = @existing_semesters + Program.distinct.pluck(:valid_end)
    @existing_semesters = @existing_semesters + Course.distinct.pluck(:valid_end)
    @existing_semesters = @existing_semesters.uniq.sort
  end

  # Only allow a list of trusted parameters through.
  def semester_params
    params.permit(:new_semester_season, :new_semester_year, :copy_semester_season, :copy_semester_year)
  end

end
