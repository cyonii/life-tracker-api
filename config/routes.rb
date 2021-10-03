Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, except: [:index]
      resources :activities, only: %i[index show]
      resources :records
      post 'auth', to: 'authentication#authenticate'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
