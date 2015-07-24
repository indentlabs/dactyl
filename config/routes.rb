Rails.application.routes.draw do
  get '/' => 'web#index'
  post '/' => 'web#index'

  scope :api do
    scope :v1 do
      get '/dactyl' => 'api#dactyl'
    end
  end
end
