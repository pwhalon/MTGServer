Rails.application.routes.draw do
  get 'magic', to: 'magic#index'
  get 'magic/index', to: 'magic#index'
  get 'magic/search', to: 'magic#search'

  get 'transaction', to: 'transaction#index'
  get 'transaction/index', to: 'transaction#index'
  get 'transaction/add_cards', to: 'transaction#index'
  post 'transaction/add_cards', to: 'transaction#add_cards'

  get 'deck', to: 'deck#index'
  get 'deck/index', to: 'deck#index'
  get 'deck/new', to: 'deck#new'
  post 'deck/create', to: 'deck#create'
  get 'deck/add_cards', to: 'deck#add_cards'
  get 'deck/search_cards', to: 'deck#search_cards'

  root 'magic#index'

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
