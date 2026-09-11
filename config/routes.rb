Rails.application.routes.draw do
  root "pages#home"
  get "shop", to: "products#index", as: :shop
  get "products/:slug", to: "products#show", as: :product
end
