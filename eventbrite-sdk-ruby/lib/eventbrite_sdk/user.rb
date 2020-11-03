module EventbriteSDK
  class User < Resource
    resource_path 'users/:id'

    # NOTE: This name is pretty legacy. We should consider renaming
    # to "orders" to normalize things.
    has_many :owned_event_orders, object_class: 'Order', key: :orders

    schema_definition do
      string 'name'
      string 'first_name'
      string 'last_name'
      string 'emails'
      string 'image_id'
    end

    def self.me
      new('id' => 'me')
    end
  end
end
