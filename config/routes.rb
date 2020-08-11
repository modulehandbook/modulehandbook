Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'
  resources :users, only: [:index, :show, :edit, :update]
  resources :course_programs
  resources :courses
  resources :programs
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'course_json', to: 'courses#course_json'
  get 'courses_json', to: 'courses#courses_json'
  get 'program_json', to: 'programs#program_json'
  get 'programs_json', to: 'programs#programs_json'
end
