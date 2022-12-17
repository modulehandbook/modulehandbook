Rails.application.routes.draw do
  resources :faculties

  root 'welcome#index'

  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  get 'users/list', to: 'users#list', as: 'users_list'
  resources :users, only: %i[index show edit update destroy]

  resources :versions, only: %i[index]
  resources :course_programs
  resources :courses
  resources :programs
  resources :comments, only: %i[create edit update destroy]

  get 'programs/:id/overview', to: 'programs#overview', as: 'program_overview'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'courses/:id/versions', to: 'courses#versions', as: 'course_versions'

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
  post 'revert_to', to: 'courses#revert_to'

  get 'approve_user', to: 'users#approve'
end
