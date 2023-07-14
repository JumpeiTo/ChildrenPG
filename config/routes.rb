Rails.application.routes.draw do
  get 'places/search', to: 'places#search', as: 'places_search'
  get 'places/detailed_search', to: 'places#detailed_search', as: 'places_detailed_search'

  # 顧客用
  # URL /customers/sign_in ...
  devise_for :customers, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  
  scope module: :public do
    root to: 'homes#top'
    resources :playgrounds, only: [:create, :show]
    resources :posts, only: [:index, :show, :edit, :update, :new, :create, :destroy] do
      resources :post_comments, only: [:create, :destroy, :edit, :update]
      resource :post_favorites, only: [:create, :destroy]
    end
  end
  
  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }
  
  namespace :admin do
    resources :tags, only: [:index, :create, :edit, :update, :destroy]
  end
end
