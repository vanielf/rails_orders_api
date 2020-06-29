Rails.application.routes.draw do

  resources :orders, only: [:index, :show, :update, :create] do
    collection do
      get :financial_report
    end
  end

  resources :batches, only: [:index, :show, :create] do
    member do
      patch :close
      patch :sent
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
