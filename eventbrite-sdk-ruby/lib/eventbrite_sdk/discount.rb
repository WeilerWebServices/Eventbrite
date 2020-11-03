module EventbriteSDK
  class Discount < Resource
    ACCESS_HIDDEN_TICKETS = 'access'.freeze # unlock access to hidden tickets
    ACCESS_HOLDS = 'hold'.freeze            # unlock access to HoldClasses (reserved seating)
    PROTECTED_DISCOUNT = 'coded'.freeze     # unlock a discount
    PUBLIC_DISCOUNT = 'public'.freeze       # a publicly available discount

    TYPES = [
      ACCESS_HIDDEN_TICKETS,
      ACCESS_HOLDS,
      PROTECTED_DISCOUNT,
      PUBLIC_DISCOUNT
    ].freeze

    resource_path 'discounts/:id'

    belongs_to :event, object_class: 'Event'
    belongs_to :ticket_group, object_class: 'TicketGroup'

    attributes_prefix 'discount'

    schema_definition do
      string 'amount_off'           # Fixed reduction amount as a decimal - "12.99".
      string 'code'                 # required: Code used to activate discount.
      string 'discount_type'        # required: Type of discount. (Valid choices are: access, hold, coded, or public)
      string 'end_date'             # Allow use until this date.
      integer 'end_date_relative'   # Allow use until this number of seconds before the event starts.
      string 'event_id'             # ID of the event. Only used for single event discounts.
      string 'hold_ids'             # IDs of holds this discount can unlock
      string 'percent_off'          # Percentage reduction. Supports 2 digit decimal precision - "50" or "50.01".
      integer 'quantity_available'  # Number of discount uses.
      string 'start_date'           # Allow use from this date.
      integer 'start_date_relative' # Allow use from this number of seconds before the event starts.
      string 'ticket_group_id'      # ID of the ticket group
      string 'ticket_ids'           # IDs of tickets to limit discount to
    end


    def access_hidden_tickets?
      discount_type == ACCESS_HIDDEN_TICKETS
    end

    def access_holds?
      discount_type == ACCESS_HOLDS
    end

    def discount?
      protected_discount? || public_discount?
    end

    def protected_discount?
      discount_type == PROTECTED_DISCOUNT
    end

    def public_discount?
      discount_type == PUBLIC_DISCOUNT
    end

    #
    # Ticket groups that are auto created for all tickets of an org can NOT be
    # accessed through the API, even though the ticket_group_id is present.
    #
    # We expand ticket_group on all queries - so ticket_group_id exists
    # for that group, and ticket_group is present with a nil value in the data.
    # In that case, when you call Discount#ticket_group the resource would
    # attempt to retrieve it... and the API would return a 404 response. Bad.
    #
    # You can't use Discount#ticket_group unless it's safe to do so.
    # You have to check the attribute data to verify that calling #ticket_group
    # will not try to retrieve a "forbidden" group and raise an exception
    #
    def ticket_group_accessible?
      !ticket_group_id.nil? &&
        attrs.respond_to?(:ticket_group) &&
        !attrs['ticket_group'].nil?
    end
  end
end
