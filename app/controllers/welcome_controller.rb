class WelcomeController < ApplicationController
  def new
    @secured_api_key = Algolia.generate_secured_api_key(ENV['ALGOLIA_API_KEY_SEARCH_ONLY'], "user_#{current_user.uid}") if current_user
  end

  def event
    @event = Event.where(uid: params[:id]).first
    @secured_api_key = Algolia.generate_secured_api_key(ENV['ALGOLIA_API_KEY_SEARCH_ONLY'], "user_#{@event.member_uid},event_#{@event.uid}")
    render action: :new
  end
end
