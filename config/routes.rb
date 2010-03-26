ActionController::Routing::Routes.draw do |map|
  map.resources :customers, :member => ['mail'], :collection => ['autocomplete']
end
