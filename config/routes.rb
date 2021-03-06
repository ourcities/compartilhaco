Rails.application.routes.draw do
  root to: 'campaigns#index'

  resources :campaigns, except: [:new, :create] do
    member do
      get 'images/:trash', to: 'campaigns#serve_image', as: :serve_image
      patch :archive, to: "campaigns#archive"
      get :twitter_form, defaults: { form: "twitter" }, as: :twitter_form, to: "campaigns#show"
    end
    resources :spam_reports, only: [:create]
  end

  resources :campaign_spreaders do
    collection do
      post(
      'create_for_facebook_profile',
      to: 'campaign_spreaders#create_for_facebook_profile',
      as: :create_for_facebook_profile
      )

      post(
      'create_for_twitter_profile',
      to: 'campaign_spreaders#create_for_twitter_profile',
      as: :create_for_twitter_profile
      )
    end
  end

  get '/auth/facebook/callback', to: 'campaign_spreaders#create_for_facebook_profile_callback'
  get '/auth/twitter/callback', to: 'campaign_spreaders#create_for_twitter_profile_callback'
  get '/auth/failure', to: 'campaign_spreaders#failure'

  get '/about', to: "pages#about", as: :about

  get ENV['CAS_SERVER_URL'] => 'campaigns#index', as: :login if Rails.env.test?
end
