Rails.application.routes.draw do
  resources :lessons do
    member do
      post :submit_quiz
    end
    resources :questions, except: [ :index, :show ]
  end
  resources :topics
  devise_for :users
  # Tambahkan baris ini untuk mengatur halaman utama
  root "topics#index"
end
