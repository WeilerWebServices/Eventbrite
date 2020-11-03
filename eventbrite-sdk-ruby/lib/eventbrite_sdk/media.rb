module EventbriteSDK
  # This module implements media upload to Eventbrite based on:
  # https://docs.evbhome.com/apidocs/reference/uploads/?highlight=logo
  class Media < Resource
    resource_path 'media/:id'

    attr_reader :image_type, :file

    VALID_TYPES = {
      event_logo: 'image-event-logo',
      organizer_logo: 'image-organizer-logo',
      user_photo: 'image-user-photo',
      event_view_from_seat: 'image-event-view-from-seat'
    }.freeze

    schema_definition do
      string 'crop_mask'
      string 'original'
      string 'id'
      string 'url'
      string 'aspect_ratio'
      string 'edge_color'
      string 'edge_color_set'
    end

    def upload!(image_type, file)
      # Media uploads through the API involve a multiple step process:

      # 1. Retrieve upload instructions + an upload token from the API
      instructions = get_instructions(image_type)

      # 2. Upload the file to the endpoint specified in the upload instructions
      eventbrite_upload(file, instructions)

      # 3. When the upload has finished, notify the API by re-sending the
      #    upload token from step 1
      notify(instructions['upload_token'])

      true
    end

    private

    def get_instructions(image_type, request = EventbriteSDK)
      type = VALID_TYPES[image_type]

      unless type
        raise ArgumentError, "image_type needs to be one of #{VALID_TYPES.keys}"
      end

      request.get(url: path('upload'), query: { type: type })
    end

    def eventbrite_upload(file, instructions)
      RestClient.post(
        instructions['upload_url'],
        instructions['upload_data'].merge(file: file),
        multipart: true
      )
    end

    def notify(upload_token, request = EventbriteSDK)
      response = request.post(
        url: path('upload'), payload: { upload_token: upload_token }
      )

      if payload['crop_mask']
        response = request.post(url: path(response['id']), payload: payload)
      end

      reload(response)
    end
  end
end
