class SessionsController < ApplicationController

  def new
    redirect_to '/auth/meetup'
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.where(uid: auth['uid']).first || User.create_with_omniauth(auth)
    user.update_attributes token: auth['credentials']['token'], refresh_token: auth['credentials']['refresh_token'], reindexing_progress: 0
    hipchat_notify! "#{user.name} signed in", color: :green, notify: true
    user.delay.reindex!
    reset_session
    session[:user_id] = user.id
    redirect_to root_url, :notice => 'Signed in!'
  end

  def destroy
    reset_session
    redirect_to root_url, :notice => 'Signed out!'
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end

  def progress
    render json: {
      progress: (current_user && current_user.reindexing_progress) || 0
    }
  end

end
