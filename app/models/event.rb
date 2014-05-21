class Event < ActiveRecord::Base

  def name
    raw['name']
  end

  private
  def raw
    @json ||= JSON.parse(raw_cache)
  end

end
