class Member < ActiveRecord::Base

  def self.create_with_json(uid, raw)
    Member.create(uid: uid, raw_cache: raw)
  end

  def to_json(user_id, event_id, event, response)
    raw.merge(uid: uid, objectID: "#{user_id}_#{event_id}_#{uid}", event: event, _tags: [ "user_#{user_id}", "event_#{event_id}", "response_#{response}" ])
  end

  protected
  def raw
    @raw ||= JSON.parse(read_attribute(:raw_cache))
  end

end
