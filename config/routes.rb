Rails.application.routes.draw do
  
  get 'login/admin'
  get 'login/user'
  
  post 'login/sign_in_admin'
  post 'login/sign_in_user'
  
  post 'login/log_out'


  resources :users
  resources :attendances do
    collection do
      post 'filter'
    end
  end

  root "login#admin"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
