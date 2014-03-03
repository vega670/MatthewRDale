MatthewRDale::Application.routes.draw do
  resources :articles

  resources :pages do
    get 'home'
    get 'bio'
  end

  root 'pages#home'
end
