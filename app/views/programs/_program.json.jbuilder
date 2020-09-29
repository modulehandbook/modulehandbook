json.extract! program, :id, :name, :code, :mission, :degree, :ects
json.url program_url(program, format: :json)
json.courses do
  json.array! @course_programs do | cp_link |
    json.extract! cp_link, :semester, :required
    json.extract! cp_link.course, :code, :name, :mission, :ects, :examination, :objectives, :contents, :prerequisites, :literature, :methods, :skills_knowledge_understanding, :skills_intellectual, :skills_practical, :skills_general, :created_at, :updated_at, :lectureHrs, :labHrs, :tutorialHrs, :equipment, :room
  end
end
