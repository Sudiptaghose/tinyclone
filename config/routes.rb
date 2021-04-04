Rails.application.routes.draw do
  get "/", to: 'url#home'
  post "/", to: 'url#shorten'
  get '/:short_url', to: 'url#go_to_link'
  get '/:short_url/stats', to: 'url#stats'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
