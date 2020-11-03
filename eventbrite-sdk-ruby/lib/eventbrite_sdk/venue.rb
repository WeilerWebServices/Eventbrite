module EventbriteSDK
  class Venue < Resource
    resource_path 'venues/:id'

    attributes_prefix 'venue'

    schema_definition do
      address 'address'
      string 'age_restriction'
      string 'capacity'
      string 'latitude'
      string 'longitude'
      string 'name'
    end
  end
end
