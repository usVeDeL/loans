Rails.application.routes.draw do
  get 'loan_reports/recents', to: 'loan_reports#recents'
  get 'loan_reports/interests_montly', to: 'loan_reports#interests_montly'
  get 'loan_reports/extensions', to: 'loan_reports#extensions'
  get 'loan_reports/clients', to: 'loan_reports#client_loans'
  get 'logs/index'
  post '/send_contact_email', to: 'static_pages#send_contact_email'
  get '/download_contract/:id', to: 'contracts#download_contract'
  get '/download_pagare/:id', to: 'contracts#download_pagare'
  resources :contracts
  resources :logs, only: [:index]
  resources :loans
  resources :clients
  resources :roles
  resources :states
  resources :movement_types
  resources :contact_types
  resources :document_types
  resources :client_address
  resources :client_contact_types
  resources :personal_documents
  resources :loan_clients, only: [:create, :destroy]
  resources :loan_movements
  devise_for :users, controllers: {:registrations => "registrations"}
  post '/add_client', to: 'clients#add_client'
  put '/pay_full_loan', to: 'loans#pay_full'
  post '/search_clients', to: 'clients#search_clients'
  as :user do
    get "/register", to: "registrations#new", as: "register"
    get '/users/sign_out' => 'devise/sessions#destroy' 
  end

  root "static_pages#home"
  get '/index', to: 'static_pages#index'
  resources :users, only: [:index, :edit, :update, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
