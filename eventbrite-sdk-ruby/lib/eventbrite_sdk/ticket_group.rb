module EventbriteSDK
  class TicketGroup < Resource
    ARCHIVED = 'archived'.freeze
    DELETED = 'deleted'.freeze
    LIVE = 'live'.freeze
    STATUSES = [ARCHIVED, DELETED, LIVE].freeze

    resource_path 'ticket_groups/:id'

    attributes_prefix 'ticket_group'

    schema_definition do
      string 'event_ticket_ids' # hash...
                                #   key:   event_id
                                #   value: array of ticket_class ids
                                #   { "36235711990": ["69685575"] }
      string 'name'             # name of the ticket group
      string 'status'           # can be any of the statuses above
    end

    # Helper methods to check the status value
    #   archived?
    #   deleted?
    #   live?
    STATUSES.each do |value|
      define_method(:"#{value}?") { status == value }
    end
  end
end
