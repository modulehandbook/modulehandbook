Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'
  resources :users, only: [:index, :show, :edit, :update]
  resources :course_programs
  resources :courses
  resources :programs
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # JSON Exporte
  get 'export_course_json', to: 'courses#export_course_json'
  get 'export_courses_json', to: 'courses#export_courses_json'
  get 'export_program_json', to: 'programs#export_program_json'
  get 'export_programs_json', to: 'programs#export_programs_json'
  # JSON Importe
  post 'import_course_json', to: 'courses#import_course_json'
  post 'import_program_json', to: 'programs#import_program_json'

end
