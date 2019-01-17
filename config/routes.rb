Rails.application.routes.draw do
  resources :books
  resources :characters
  resources :genres
  resources :publishers
  resources :authors
  root 'dactylograms#new'

  devise_for :users, controllers: {
                       omniauth_callbacks: 'callbacks',
                       registrations:      'registrations'
                     },
                     class_name: 'OauthUser'

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
end
