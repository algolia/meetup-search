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
    event = Event.find_by!(slug: params[:id])
    tags = "user_#{event.member_uid},event_#{event.uid}"
    render json: {
      api_key: Algolia.generate_secured_api_key(ENV['ALGOLIA_API_KEY_SEARCH_ONLY'], tags),
      tags: tags,
      data: event.raw
    }
  end

  def events
    render json: {
      data: Event.where(member_uid: current_user && current_user.uid).map { |e| e.raw.merge(slug: e.slug) }.sort_by { |e| e['time'] }.reverse
    }
  end
end
