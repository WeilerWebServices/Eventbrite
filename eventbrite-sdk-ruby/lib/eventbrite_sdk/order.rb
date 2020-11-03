module EventbriteSDK
  class Order < Resource
    resource_path 'orders/:id'

    has_many :attendees, object_class: 'Attendee'
    belongs_to :event, object_class: 'Event'

    schema_definition do
      string 'name'
      string 'first_name'
      string 'last_name'
      string 'email'
      string 'costs'
      utc 'created', read_only: true
      utc 'changed', read_only: true
      string 'resource_uri', read_only: true
    end
  end
end
