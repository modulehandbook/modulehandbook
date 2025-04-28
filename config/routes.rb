# frozen_string_literal: true

Rails.application.routes.draw do
  relative_root = ENV.fetch('RAILS_RELATIVE_URL_ROOT', '')

  scope relative_root do
    resources :topic_descriptions, only: %i[index create show edit update destroy]
    get 'topic_descriptions/new/:topic_id/:course_id', to: 'topic_descriptions#new', as: :new_topic_description

    resources :topics, only: %i[index create show edit update destroy]
    get 'topics/new/:program_id', to: 'topics#new', as: :new_topic

    resources :faculties

    root 'welcome#index'

    devise_for :users
    devise_scope :user do
      get '/users/sign_out' => 'devise/sessions#destroy'
    end

    authenticated :user do
      root to: 'welcome#index', as: :authenticated_root
    end

    get 'abilities', to: 'abilities#index', as: 'abilities'
    resources :users, only: %i[index show edit update destroy]

    resources :versions, only: %i[index]
    resources :course_programs
    resources :courses
    resources :programs
    get 'programs/:id/copy', to: 'programs#copy', as: 'copy_program'
    resources :comments, only: %i[index show create edit update destroy]

    get 'programs/:id/overview', to: 'programs#overview', as: 'program_overview'
    get 'programs/:id/htw_overview', to: 'programs#htw_overview', as: 'program_htw_overview'
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
    post 'programs/:id/add_courses', to: 'programs#import_courses_json', as: 'program_add_courses'
    # DOCX Exporte
    get 'export_course_docx', to: 'courses#export_course_docx'
    get 'export_program_docx', to: 'programs#export_program_docx'

    post 'change_state', to: 'courses#change_state'
    post 'revert_to', to: 'courses#revert_to'

    get 'approve_user', to: 'users#approve'
  end
end
