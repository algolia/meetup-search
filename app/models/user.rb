require 'ruby_meetup'

class User < ActiveRecord::Base
  validates_presence_of :name

  def self.create_with_omniauth(auth)
    create! do |user|
      user.uid = auth['uid']
      if auth['info']
         user.name = auth['info']['name'] || ""
         user.email = auth['info']['email'] || ""
      end
      user.token = auth['credentials']['token']
      user.refresh_token = auth['credentials']['refresh_token']
    end
  end

  def refresh_token!
    return if @refreshed
    response = JSON.parse RestClient.post("https://secure.meetup.com/oauth2/access", {
      client_id: ENV['OMNIAUTH_PROVIDER_KEY'],
      client_secret: ENV['OMNIAUTH_PROVIDER_SECRET'],
      grant_type: 'refresh_token',
      refresh_token: self.refresh_token
    })
    update_attributes token: response['access_token'], refresh_token: response['refresh_token']
    @client = nil
    @refreshed = true
  end

  def profile
    refresh_token!
    @profile ||= JSON.parse meetup_client.get_path("/2/member/#{uid}")
  end

  def events(offset = 0, page = 20)
    refresh_token!
    @events ||= JSON.parse(meetup_client.get_path("/2/events", rsvp: 'yes,maybe,waitlist', limited_events: true, member_id: uid, offset: offset, page: page, status: 'upcoming,past', desc: true))['results']
  end

  def rsvps(event_id)
    refresh_token!
    results = []
    page = 50
    offset = 0
    loop do
      r = JSON.parse(meetup_client.get_path("/2/rsvps", event_id: event_id, offset: offset, page: page))['results']
      results += r
      break if r.length != page
      offset += 1
    end
    results
  end

  def reindex!
    percent = 0
    event_percent = 100.0 / events.size
    events.each do |e|
      event_id = e.delete('id')
      EVENTS_INDEX.add_object e.merge(objectID: "#{uid}_#{event_id}", _tags: [ "user_#{uid}" ])
      members = []
      rlist = rsvps(event_id)
      rsvp_percent = event_percent / rlist.size
      group_id = e['group']['id']
      rlist.each do |r|
        member_uid = r['member']['member_id']
        m = Member.where(uid: member_uid).first || Member.create_with_json(member_uid, meetup_client.get_path("/2/member/#{member_uid}", fields: 'membership_count'))
        gm = GroupMember.where(gid: group_id, uid: member_uid).first || GroupMember.create_with_json(group_id, member_uid, meetup_client.get_path("/2/profile/#{group_id}/#{member_uid}"))
        members << m.to_json(uid, event_id, { name: e['name'], url: e['event_url'], time: e['time'], utc_offset: e['utc_offset'], venue: e['venue'], bio: gm.bio, role: gm.role }, r['response'])
        percent += rsvp_percent
        update_attribute :reindexing_progress, percent
        sleep 0.1 if m.id_changed? || gm.id_changed? # throttling...
      end
      RSVPS_INDEX.add_objects members
    end
    update_attribute :reindexing_progress, 100
    nil
  end

  private
  def meetup_client
    if @client.nil?
      @client = RubyMeetup::AuthenticatedClient.new
      @client.access_token = token
    end
    return @client
  end

end
