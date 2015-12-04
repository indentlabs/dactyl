Rails.application.routes.draw do
  get '/' => 'web#index'
  post '/' => 'web#index'

  get '/upload' => 'web#upload'
  post '/upload' => 'web#upload'

  get '/analysis/:id' => 'web#show', as: 'show_dactylogram'

  scope :api do
    scope :v1 do
      get '/dactyl' => 'api#dactyl'
    end
  end
end
