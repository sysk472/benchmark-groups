Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :groups, defaults: { format: :json }
  get '/group_tree/:group_id', action: :show, controller: 'groups', as: :group_tree, defaults: { format: :json }
  get '/change_root_structure/:group_id', action: :change_root_structure, controller: 'groups'
end
