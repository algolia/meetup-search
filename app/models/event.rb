class Event < ActiveRecord::Base

  def raw
    @json ||= JSON.parse(raw_cache)
  end

end
