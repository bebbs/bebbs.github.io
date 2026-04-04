Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
  get "/posts/:slug", to: "posts#show", as: :post
  get "/tags", to: "tags#index", as: :tags
  get "/tags/:slug", to: "tags#show", as: :tag
  get "/:slug", to: "pages#show", as: :page
end
