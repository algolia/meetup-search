require 'securerandom'

class Event < ActiveRecord::Base

  before_create :generate_slug

  def raw
    @json ||= JSON.parse(raw_cache)
  end

  private
  def generate_slug
    self.slug = SecureRandom.urlsafe_base64(15).tr('lIO0', 'sxyz')
  end

end
