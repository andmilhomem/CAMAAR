Rails.application.routes.draw do
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # rota de exemplo para testar se cucumber está funcionando
  get "/hello", to: "pages#hello"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Rotas relacionadas à manipulação direta de recursos
  resources :formularios, only: [:index, :new, :create] # Usar index para listar formulários não respondidos (usar usuario_id em session para filtrar) 
  resources :resposta_formularios, only: [:index, :new, :create] # Usar index para listar formulários com resposta (quando não houver parâmetro formulario_id) e para gerar CSV com todos os resultados de um formulário (passar formulario_id como parâmetro quando clicar em card)
  resources :templates, only: [:index, :new, :create, :edit, :update, :destroy]

  # Define a página inicial
  root "formularios#index"

  # Rotas relacionadas ao login
  get     "/login",   to: "sessoes#new",     as: :login
  post    "/login",   to: "sessoes#create"
  delete  "/logout",  to: "sessoes#destroy", as: :logout
  
  # Rotas relacionadas à redefinação de senha
  get 'senha/esqueci', to: 'senhas#new', as: :esqueci_senha
  post 'senha/esqueci', to: 'senhas#create'
  get 'senha/redefinir', to: 'senhas#edit', as: :redefinir_senha
  patch 'senha/redefinir', to: 'senhas#update'


  # Rotas relacionadas ao administrador
  get   "/admin",                 to: "admin#index",    as: :admin
  post  "/admin/importar_dados",  to: "admin#importar_dados", as: :importar_dados

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
