Rails.application.routes.draw do
  resources :faculties

  root 'welcome#index'

  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  get 'abilities', to: 'users#show_abilities', as: 'abilities'
  resources :users, only: %i[index show edit update destroy]

  resources :course_programs
  resources :courses
  resources :programs
  resources :comments , only: %i[show create edit update destroy]
  resources :semesters, only: %i[index new]
  post 'semester_generate', to: 'semesters#generate'

  get 'programs/:id/overview', to: 'programs#overview', as: 'program_overview'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'courses/:id/versions', to: 'courses#versions', as: 'course_versions'
  get 'programs/:id/versions', to: 'programs#versions', as: 'program_versions'
  get 'course_programs/:id/versions', to: 'course_programs#versions', as: 'course_program_versions'

  # JSON Exporte
  get 'export_course_json', to: 'courses#export_course_json'
  get 'export_courses_json', to: 'courses#export_courses_json'
  get 'export_program_json', to: 'programs#export_program_json'
  get 'export_programs_json', to: 'programs#export_programs_json'
  # JSON Importe
  post 'import_course_json', to: 'courses#import_course_json'
  post 'import_program_json', to: 'programs#import_program_json'
  # DOCX Exporte
  get 'export_course_docx', to: 'courses#export_course_docx'
  get 'export_program_docx', to: 'programs#export_program_docx'

  post 'change_state', to: 'courses#change_state'
  post 'course_revert_to', to: 'courses#revert_to'
  post 'program_revert_to', to: 'programs#revert_to'
  post 'course_program_revert_to', to: 'course_programs#revert_to'

  get 'approve_user', to: 'users#approve'
end
