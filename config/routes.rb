MeetupSearch::Application.routes.draw do
  get "templates/event"
  get "templates/home"
  get "/auth/:provider/callback" => "sessions#create"
  get "/auth/failure", to: redirect('/')

  delete "/signout" => "sessions#destroy", as: :signout

  get '/events/:id', as: :event, controller: 'welcome', action: 'event'
  get '/user', as: :user, controller: 'welcome', action: 'credentials'

  # backward compatibility
  get '/e/:event_id' => redirect { |params, request| "/#/events/#{params[:event_id]}" }

  # TODO
  # match '/progress', via: [:get, :post, :xhr], as: :progress, controller: 'sessions', action: 'progress'

  root "welcome#new"
end
