class Program < ApplicationRecord
  has_many :course_programs, dependent: :destroy
  has_many :courses, through: :course_programs
  def select_name
    "#{name} (#{code})"
  end
end
