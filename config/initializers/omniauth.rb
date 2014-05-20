Rails.application.config.middleware.use OmniAuth::Builder do
  provider :meetup, ENV['OMNIAUTH_PROVIDER_KEY'], ENV['OMNIAUTH_PROVIDER_SECRET']
end
