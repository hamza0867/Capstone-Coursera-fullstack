# frozen_string_literal: true

Rails.application.routes.draw do
  resources :states
  scope :api, defaults: { format: :json } do
    resources :foos, :bars
    resources :cities, only: %i[index show]
    resources :states, only: %i[index show]
  end
  get '/ui' => 'ui#index'
  get '/ui#' => 'ui#index'
  root 'ui#index'
end
