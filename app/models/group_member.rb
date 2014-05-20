class GroupMember < ActiveRecord::Base
  def self.create_with_json(gid, uid, raw)
    GroupMember.create(gid: gid, uid: uid, raw_cache: raw)
  end

  def bio
    raw['bio']
  end

  def role
    raw['role']
  end

  protected
  def raw
    @raw ||= JSON.parse(read_attribute(:raw_cache))
  end
end
