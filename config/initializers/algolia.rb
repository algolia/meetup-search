Algolia.init application_id: ENV['ALGOLIA_APPLICATION_ID'], api_key: ENV['ALGOLIA_API_KEY']

EVENTS_INDEX = Algolia::Index.new("meetup_events_#{Rails.env}")
EVENTS_INDEX.set_settings({
  attributesToIndex: ['name', 'venue.name', 'venue.city'],
  customRanking: ['desc(time)']
})

RSVPS_INDEX = Algolia::Index.new("meetup_rsvps_#{Rails.env}")
RSVPS_INDEX.set_settings({
  attributesToIndex: ['name', 'bio', 'event.bio', 'city', 'unordered(event.name)', 'other_services.twitter.identifier', 'event.venue.name'],
  attributesForFaceting: ['topics.name', 'city', 'event.name', 'event.venue.name'],
  attributeForDistinct: 'uid',
  customRanking: ['desc(membership_count)', 'asc(name)', 'desc(event.time)']
})
