ESSCR2::Application.routes.draw do

  # Miracle ... route définie pour updater juste les stats
  match "events/:event_id/service/:id/update_stats" => "services#update_stats"
  
  match "seritems/:id/move_up"   => "seritems#move_up"
  match "seritems/:id/move_down" => "seritems#move_down"
  #match "seritems/:id/destroy"   => "seritems#destroy",   :as => :seritem_destroy
  
  match "events/:id/overview"            => "events#overview"           , :as => :event_overview
  match "events/:id/fullitem"            => "events#fullitem"           , :as => :event_fullitem
  match "events/:id/add_to_invoice"      => "events#add_to_invoice"
  match "events/:id/remove_from_invoice" => "events#remove_from_invoice"

  # image plein écran
# match "dispositifs/:id" => "dispositifs#code_image"
  # image inline
  match "dispositifs/code_image_s1/:id" => "dispositifs#code_image_s1"
  match "dispositifs/code_image_s2/:id" => "dispositifs#code_image_s2"
  match "dispositifs/code_image_s4/:id" => "dispositifs#code_image_s4"

  match "events/:event_id/services/:id/overview"    => "services#overview",    :as => :event_service_overview
  match "events/:event_id/services/:id/stats"       => "services#stats",       :as => :event_service_stats

  match "evitems/:id/move_up"   => "evitems#move_up"
  match "evitems/:id/move_down" => "evitems#move_down"

  match "nositems/:id/move_up"   => "nositems#move_up"
  match "nositems/:id/move_down" => "nositems#move_down"
  
  match "invoices/:id/events"   => "invoices#events",   :as => :invoice_events
  match "invoices/:id/overview" => "invoices#overview", :as => :invoice_overview

  match "volos/:id/overview" => "volos#overview", :as => :volo_overview
  
  match "home" => "home#index", :as => :home
  
  match 'tools/montants' => 'tools#montants', :as => :montants
  
  match "tools" => "tools#index", :as => :tools
  scope "/tools" do
    resources :templitems, :customers, :crentites
  end
  
  resources :categories
  resources :invoice_item_templates

  resources :invoices do
    resources :nositems
  end

  resources :events do
    resources :evitems
    resources :refacs
    resources :services do
      resources :seritems
      resources :servolos
      resources :disposers
    end
  end

  resources :volos
  resources :dispositifs


  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
