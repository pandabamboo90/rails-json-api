Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, format: "json" do
    namespace :v1 do
      #
      # Public routes
      #
      namespace :public do
        # Your public routes (not require auth, landing page ...) go here
      end

      #
      # Authentication routes
      #
      mount_devise_token_auth_for "Admin", at: "auth_admin", controllers: {
        passwords: "overrides/passwords",
        sessions: "overrides/sessions",
        token_validations: "overrides/token_validations"
      }
      mount_devise_token_auth_for "User", at: "auth_user", controllers: {
        passwords: "overrides/passwords",
        sessions: "overrides/sessions",
        token_validations: "overrides/token_validations"
      }

      #
      # Features routes
      #

      get "/me/profile", to: "me#show"
      put "/me/profile", to: "me#update"

      resources :admins do
        member do
          put "restore", to: "admins#restore"
        end
      end
      resources :users do
        member do
          put "restore", to: "users#restore"
        end
      end
      resources :roles, only: [:index]
      resources :permissions, only: [:index]

      get "roles_permissions", to: "roles_permissions#index"
      put "roles_permissions", to: "roles_permissions#update"
    end
  end

  root to: "application#index"
end
