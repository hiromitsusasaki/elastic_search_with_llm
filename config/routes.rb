Rails.application.routes.draw do
  root 'pages/root#index'
  namespace :bookmarks do
    get 'search', to: 'search#index'
    get 'inquiry', to: 'inquiry_in_natural_language#index'
  end
  namespace :google_search do
    get 'inquiry', to: 'inquiry_in_natural_language#index'
  end
end
