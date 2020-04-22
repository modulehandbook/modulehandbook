class Program < ApplicationRecord
  has_many :course_programs
  has_many :courses, through: :course_programs
end
