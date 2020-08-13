class Course < ApplicationRecord
  has_many :course_programs, dependent: :destroy
  has_many :programs, through: :course_programs
  def select_name
    "#{name} (#{code})"
  end

  def self.create_from_json(data)
    # TODO: Wenn es den Kurs schon gibt: den aus JSON oder den aus der DB nehmen?
    existing_course = Course.find_by(code: data['code'])
    if !existing_course.nil?
      course = existing_course
    else
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
    end
    course.save
    course
  end
end
