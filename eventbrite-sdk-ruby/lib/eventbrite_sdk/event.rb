module EventbriteSDK
  class Event < Resource
    ERROR_CANNOT_UNPUBLISH = 'CANNOT_UNPUBLISH'.freeze
    ERROR_ALREADY_PUBLISHED_OR_DELETED = 'ALREADY_PUBLISHED_OR_DELETED'.freeze
    ERROR_ALREADY_CANCELED = 'ALREADY_CANCELED'.freeze

    STATUS_CANCELED = 'canceled'.freeze
    STATUS_COMPLETED = 'completed'.freeze
    STATUS_DELETED = 'deleted'.freeze
    STATUS_ENDED = 'ended'.freeze
    STATUS_LIVE = 'live'.freeze
    STATUS_STARTED = 'started'.freeze

    # Defines event#cancel, event#publish, and event#unpublish
    #
    # When an event has an id the POST is made, otherwise we return false
    # POSTS to event/:id/(cancel|publish|unpublish)
    define_api_actions :cancel, :publish, :unpublish

    resource_path 'events/:id'

    attributes_prefix 'event'

    belongs_to :organizer, object_class: 'Organizer'
    belongs_to :venue, object_class: 'Venue'

    has_many :orders, object_class: 'Order'
    has_many :attendees, object_class: 'Attendee'
    has_many :ticket_classes, object_class: 'TicketClass'
    has_many :ticket_groups, object_class: 'TicketGroup'

    schema_definition do
      multipart 'name'
      multipart 'description'
      string 'organizer_id'
      datetime 'start'
      datetime 'end'
      boolean 'hide_start_date'
      boolean 'hide_end_date'
      string 'currency'
      string 'venue_id'
      boolean 'online_event'
      boolean 'listed'
      string 'logo_id'
      string 'category_id'
      string 'subcategory_id'
      string 'format_id'
      boolean 'shareable'
      boolean 'invite_only'
      string 'password'
      integer 'capacity'
      boolean 'show_remaining'
      string 'source'
      string 'status', read_only: true
      utc 'created', read_only: true
      utc 'changed', read_only: true
      string 'resource_uri', read_only: true
    end

    def list!
      unless listed
        assign_attributes('listed' => true)
        save
      end
    end

    def over?
      [
        self.class::STATUS_CANCELED,
        self.class::STATUS_COMPLETED,
        self.class::STATUS_DELETED,
        self.class::STATUS_ENDED
      ].include?(status)
    end

    def unlist!
      if listed
        assign_attributes('listed' => false)
        save
      end
    end
  end
end
