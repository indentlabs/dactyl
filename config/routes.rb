Rails.application.routes.draw do
  root 'dactylogram#new'
  resources :dactylogram

  get '/upload' => 'dactylogram#upload'
  post '/upload' => 'dactylogram#upload'

  #get '/analysis/:reference' => 'dactylogram#show', as: 'show_dactylogram'
  get '/ghost/:reference' => 'ghost#editor'

  scope :api do
    scope :v1 do
      get '/dactyl' => 'api#dactyl'
    end
  end
end
