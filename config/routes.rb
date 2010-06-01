ActionController::Routing::Routes.draw do |map|
  map.resources :projects, :only => :none do |project|
    project.resources :customers, :member => {:mail => :post}
  end
end
