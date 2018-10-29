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

      root to: "roots#home", via: :get
    end

    match "*path", to: "v1/errors#resource_not_found",
                   via: %i[delete get head post put],
                   as: :api_v1_error

    root to: "v1/roots#home", via: :get
  end
end
