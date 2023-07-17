Rails.application.routes.draw do
  root to: 'public/homes#top'
  

  
  # public ルーティング
  scope module: :public do
    resource :customers, only: [:show, :edit, :update]
    get 'customers/check' => "customers#check"
    patch 'customers/withdrawal' => "customers#withdrawal"
    get 'customers/favorites' =>  'customers#favorites', as: 'customer_favorite_posts'
    get 'customers/comments' =>  'customers#comments', as: 'customer_comment_posts'
    
    get 'places/search', to: 'places#search', as: 'places_search'
    get 'places/detailed_search', to: 'places#detailed_search', as: 'places_detailed_search'
      
    resources :playgrounds, only: [:create, :show]
    
    resources :posts, only: [:index, :show, :edit, :update, :new, :create, :destroy] do
      resources :post_comments, only: [:create, :destroy, :edit, :update]
      resource :post_favorites, only: [:create, :destroy]
    end
  end
  
  # admin ルーティング
  namespace :admin do
    resources :tags, except: [:show, :new]
  end
  
  # devise customer ルーティング
  devise_for :customers, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  
  # devise admin ルーティング
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }
end
