# frozen_string_literal: true

Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/", to: "application#health"
  # add group events day resource index and show routes
  resources :group_events_day, path: '/counts/day/groups', only: %i[index show]

end
