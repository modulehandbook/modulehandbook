class Program < ApplicationRecord
  has_many :course_programs, dependent: :destroy
  has_many :courses, through: :course_programs
  def select_name
    "#{name} (#{code})"
  end

  def self.create_from_json(data)
    # TODO: Wenn es das Program schon gibt: das aus JSON oder das aus der DB nehmen?
    existing_program = Program.find_by(code: data['code'])
    if !existing_program.nil?
      program = existing_program
    else
      program = Program.new
      program.name = data['name']
      program.code = data['code']
      program.mission = data['mission']
      program.degree = data['degree']
      program.ects = data['ects']
    end
    program.save
    program
  end
end
