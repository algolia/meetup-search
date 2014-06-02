Meetup Search
===============

This is the Rails 4 application providing [Meetup Search](http://meetupsearch.algolia.com/). It's based on [algoliasearch-client-ruby](https://github.com/algolia/algoliasearch-client-ruby) and [omniauth-meetup](https://github.com/tapster/omniauth-meetup).

Index settings
----------------------

```ruby
Algolia.init application_id: ENV['ALGOLIA_APPLICATION_ID'], api_key: ENV['ALGOLIA_API_KEY']
RSVPS_INDEX = Algolia::Index.new("meetup_rsvps_#{Rails.env}")
RSVPS_INDEX.set_settings({
  attributesToIndex: ['name', 'bio', 'event.bio', 'city', 'unordered(event.name)', 'other_services.twitter.identifier', 'event.venue.name'],
  attributesForFaceting: ['topics.name', 'city', 'event.name', 'event.venue.name'],
  attributeForDistinct: 'uid',
  customRanking: ['desc(membership_count)', 'asc(name)', 'desc(event.time)']
})

```

Secure indexing
----------------

Each record is tagged with its owner id (Your Meetup UID) and we use a per-user [generated secured API key](http://www.algolia.com/doc#SecurityUser) to call Algolia's REST API.

```ruby
@secured_api_key = Algolia.generate_secured_api_key(ENV['ALGOLIA_API_KEY_SEARCH_ONLY'], "user_#{current_user.uid}")
```

```js
var algolia = new AlgoliaSearch('#{ENV['ALGOLIA_APPLICATION_ID']}', '#{@secured_api_key}');
algolia.setSecurityTags('user_#{current_user.uid}');
```
