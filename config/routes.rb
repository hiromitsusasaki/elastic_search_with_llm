Rails.application.routes.draw do
  root 'pages/root#index'
  namespace :bookmarks do
    get 'search', to: 'search#index'
  end
end
