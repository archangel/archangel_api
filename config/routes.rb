# frozen_string_literal: true

Archangel::Engine.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resource :site, only: %i[show]

      resources :collections, only: %i[index show] do
        resources :entries, controller: "collections/entries",
                            only: %i[index show]
      end

      resources :pages, only: %i[index show]
      resources :widgets, only: %i[index show]
    end

    match "*path", to: "api/v1/errors#not_found",
                   defaults: { format: :json },
                   via: :get,
                   as: :api_v1_error

    root to: "api/v1/homes#show", via: :get
  end
end
