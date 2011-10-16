::Refinery::Application.routes.draw do
  resources :faqs, :only => [:index, :show]

  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :faqs, :except => :show do
      collection do
        post :update_positions
      end
    end
  end
end
