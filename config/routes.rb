Rails.application.routes.draw do
  root 'dactylogram#new'

  devise_for :users, controllers: {
                       omniauth_callbacks: 'callbacks',
                       registrations:      'registrations'
                     },
                     class_name: 'OauthUser'

  resources :dactylogram do
    get '/ghost' => 'ghost#editor'
  end

  get '/upload' => 'dactylogram#upload'
  post '/upload' => 'dactylogram#upload'

  scope :api do
    scope :v1 do
      get '/dactyl' => 'api#dactyl'
    end
  end
end
