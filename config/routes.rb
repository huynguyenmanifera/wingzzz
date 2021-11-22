Rails.application.routes.draw do
  mount Tolk::Engine => '/tolk', as: 'tolk'
  devise_for :users,
             controllers: {
               registrations: 'auth/registrations',
               sessions: 'auth/sessions',
               confirmations: 'auth/confirmations',
               omniauth_callbacks: 'auth/omniauth_callbacks',
               invitations: 'auth/invitations'
             }

  devise_scope :user do
    get '/users/sign_up/success' => 'auth/registrations#success'
  end

  devise_scope :user do
    get '/teachers/sign_up' => 'auth/registrations#new_teacher'
    post '/teachers/sign_up' => 'auth/registrations#create_teacher'
  end

  if Wingzzz.config.kitchen_sink[:enabled]
    get '/kitchen-sink', to: 'kitchen_sink#index'
  end

  namespace :admin do
    resources :books do
      resource :epub
    end

    resources :users do
      post :unsubscribe, on: :member
    end

    resources :publishers

    resources :authors

    root to: 'books#index'
  end

  resources :books, only: %i[index show]

  scope module: 'account' do
    resource :account do
      post :unsubscribe, on: :member
      resource :settings
    end
  end

  resources :books do
    resource :book_session, only: %i[update]
  end

  resource :profile, only: %i[update]
  resolve('Profile') { %i[profile] }

  resource :subscription, only: %i[new create show]

  get 'subscription/new_school',
      to: 'subscriptions#new_school', as: 'new_school_subscription'
  post 'subscription/create_school',
       to: 'subscriptions#create_school', as: 'create_school_subscription'
  get 'subscriptions/teacher_options', to: 'subscriptions#teacher_options'

  root to: 'books#index'

  get 's3_files/*key', to: 's3_files#show', as: 's3_file'

  namespace :webhooks do
    post '/mollie/payment', to: 'mollie#payment'
    post '/mollie/subscription', to: 'mollie#subscription'
    get '/mollie/pay/:token', to: 'mollie#pay', as: 'mollie_payment_redirect'
  end
end
