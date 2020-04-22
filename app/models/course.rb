class Course < ApplicationRecord
  has_many :course_programs
  has_many :programs, through: :course_programs
end
