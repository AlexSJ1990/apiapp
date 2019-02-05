Rails.application.routes.draw do
  get '/', to: "pages#home", as: :home
  get 'show', to: "pages#show", as: :show
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
