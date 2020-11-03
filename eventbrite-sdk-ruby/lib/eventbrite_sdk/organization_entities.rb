class EventbriteSDK::OrgDiscount < EventbriteSDK::Discount
  resource_path create: 'organizations/:organization_id/discounts',
                update: 'discounts/:id'
end

class EventbriteSDK::OrgVenue < EventbriteSDK::Venue
  resource_path create: 'organizations/:organization_id/venues',
                update: 'venues/:id'
end

class EventbriteSDK::OrgEvent < EventbriteSDK::Event
  resource_path create: 'organizations/:organization_id/events',
                update: 'events/:id'

  belongs_to :venue, object_class: 'OrgVenue'
end
