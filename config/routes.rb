MeetupSearch::Application.routes.draw do
  get "templates/event"
  get "templates/events"
  get "templates/home"
  get "/auth/:provider/callback" => "sessions#create"
  get "/auth/failure", to: redirect('/')

  delete "/signout" => "sessions#destroy", as: :signout

  get '/events/:id', as: :event, controller: 'welcome', action: 'event'
  get '/events', as: :events, controller: 'welcome', action: 'events'
  get '/user', as: :user, controller: 'welcome', action: 'credentials'

  # backward compatibility
  get '/e/:event_id' => redirect { |params, request| "/#/e/#{params[:event_id]}" }

  match '/progress', via: [:get, :post, :xhr], as: :progress, controller: 'sessions', action: 'progress'

  root "welcome#new"
end
