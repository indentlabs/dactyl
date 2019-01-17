Rails.application.routes.draw do
  devise_for :users, controllers: {
               omniauth_callbacks: 'callbacks',
               registrations:      'registrations'
             },
             class_name: 'OauthUser'

  resources :publish_dates
  resources :chapters
  resources :books
  resources :characters
  resources :genres
  resources :publishers
  resources :authors

  resources :dactylograms do
    get '/ghost' => 'ghost#editor'
  end

  # TODO: clean these up
  get '/upload' => 'dactylograms#upload'
  post '/upload' => 'dactylograms#upload'

  scope :api do
    scope :v1 do
      get '/dactyl' => 'api#dactyl'
    end
  end

  root 'dactylograms#new'
end
