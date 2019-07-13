# frozen_string_literal: true

Rails.application.routes.draw do
  get 'authn/whoami'
  get 'authn/checkme'
  mount_devise_token_auth_for 'User', at: 'auth'

  scope :api, defaults: { format: :json } do
    resources :images do
      post 'thing_images', controller: :thing_images, action: :create
      get 'thing_images', controller: :thing_images, action: :image_things
      get 'linkable_things', controller: :thing_images, action: :linkable_things
    end
    resources :things do
      resources :thing_images, only: %i[index create update destroy]
    end
    resources :foos, :bars
    resources :cities
    resources :states
  end
  get '/ui' => 'ui#index'
  get '/ui#' => 'ui#index'
  root 'ui#index'
end
