class WelcomeController < ApplicationController
  def new
  end

  def credentials
    if current_user
      tags = "user_#{current_user.uid}"
      render json: {
        api_key: Algolia.generate_secured_api_key(ENV['ALGOLIA_API_KEY_SEARCH_ONLY'], tags),
        tags: tags
      }
    else
      render json: {}
    end
  end

  def event
    event = Event.where(uid: params[:id]).first
    tags = "user_#{event.member_uid},event_#{event.uid}"
    render json: {
      api_key: Algolia.generate_secured_api_key(ENV['ALGOLIA_API_KEY_SEARCH_ONLY'], tags),
      tags: tags,
      data: Event.where(uid: params[:id]).first.raw
    }
  end
end
