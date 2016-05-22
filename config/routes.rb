Rails.application.routes.draw do
  root 'web#index'
  get '/' => 'web#index'
  post '/' => 'web#index'

  get '/upload' => 'web#upload'
  post '/upload' => 'web#upload'

  get '/analysis/:reference' => 'web#show', as: 'show_dactylogram'

  get '/ghost' => 'ghost#editor'

  scope :api do
    scope :v1 do
      get '/dactyl' => 'api#dactyl'
    end
  end
end
