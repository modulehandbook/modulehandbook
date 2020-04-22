class Course < ApplicationRecord
  has_many :course_programs
  has_many :programs, through: :course_programs
  def select_name
    "#{name} (#{code})"
  end
end
