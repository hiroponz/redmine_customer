ActionController::Routing::Routes.draw do |map|
  map.resources :projects do |project|
    project.resources :customers, :member => {:mail => :post}
  end
end
