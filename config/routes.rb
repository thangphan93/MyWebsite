Rails.application.routes.draw do

  root :to => 'sessions#login'

  get 'login',                :to => 'sessions#login'
  post 'login_attempt',       :to => 'sessions#login_attempt'
  post 'change_password',     :to => 'sessions#change_password'
  get 'reset_password',       :to => 'sessions#reset_password'
  post 'reset_pw',            :to => 'sessions#reset_pw'
  get 'logout',               :to => 'sessions#logout'
  get 'status',               :to => 'sessions#status'
  get 'home',                 :to => 'sessions#home'
  get 'profile',              :to => 'sessions#profile'
  get 'setting',              :to => 'sessions#setting'
  get 'payment',              :to => 'sessions#payment'
  post 'add_gender',          :to => 'sessions#add_gender'
  post 'choose_program',      :to => 'sessions#choose_program'
  post 'add_subscription',    :to => 'sessions#add_subscription'
  post 'remove_subscription', :to => 'sessions#remove_subscription'
  get 'adminpage',            :to => 'admins#admin'
  post 'update_items',        :to => 'admins#update_items'
  post 'delete_items',        :to => 'admins#delete_items'
  post 'add_items',           :to => 'admins#add_items'
  post 'search_user',         :to => 'admins#search_user'
  get 'search_user',          :to => 'admins#search_user'
  post 'update_change_limit', :to => 'admins#update_change_limit'
  post 'update_coach',        :to => 'admins#update_coach'
  post 'delete_user',         :to => 'admins#delete_user'
  post 'select_coach',        :to => 'sessions#select_coach'
  resources :sessions
  resources :transactions, only: [:new, :create]
  resources :users, only: [:new, :create]



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
