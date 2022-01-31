Rails.application.routes.draw do
  resources :stats, :controller => "statistics", :only => [:index]
end
