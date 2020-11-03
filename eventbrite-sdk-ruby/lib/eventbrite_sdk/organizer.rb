module EventbriteSDK
  class Organizer < Resource
    resource_path 'organizers/:id'

    attributes_prefix 'organizer'

    has_many :events, object_class: 'Event'

    schema_definition do
      string 'name'
      multipart 'description'
      multipart 'long_description'
      string 'logo.id'
      string 'website'
      string 'twitter'
      string 'facebook'
      string 'instagram'
    end
  end
end
