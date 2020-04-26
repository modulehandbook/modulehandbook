Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'
  resources :course_programs
  resources :courses
  resources :programs
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
