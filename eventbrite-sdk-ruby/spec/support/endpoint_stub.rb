module EndpointStub
  def stub_endpoint(path: '', method: :get, status: 200, body: {})
    payload = body.is_a?(Symbol) ? file(body) : body.to_json

    path = "#{path}/" unless path.include?('?')

    stub_request(method, "https://www.eventbriteapi.com/v3/#{path}").
      to_return(body: payload, status: status)
  end

  # Mock a GET request endpoint with a specific body, or load a fixture.
  #
  #   path:   String path (no leading or trailing slashes).
  #
  #   body:   (optional) An object representing what to return.
  #
  #   fixture (optional) - Can be the name of a fixture to load, or a hash
  #           representing the fixture to load with override values.
  #     name:     The name of the fixture file to load.
  #     override: A hash with keys/values to use instead of the default
  #             fixture values.
  def stub_get(path:, body: {}, fixture: nil, status: 200)
    payload = build_payload_from_fixture(fixture) || body

    stub_endpoint(
      body: payload,
      method: :get,
      path: path,
      status: status,
    )
  end

  # Mock a post request endpoint with a specific body, or load a fixture.
  #
  #   path:   String path (no leading or trailing slashes).
  #
  #   body:   (optional) An object representing what to return.
  #
  #   fixture (optional) - Can be the name of a fixture to load, or a hash
  #           representing the fixture to load with override values.
  #     name:     The name of the fixture file to load.
  #     override: A hash with keys/values to use instead of the default
  #             fixture values.
  def stub_post(path:, body: {}, fixture: nil, status: 200)
    payload = build_payload_from_fixture(fixture) || body

    stub_endpoint(
      body: payload,
      method: :post,
      path: path,
      status: status,
    )
  end

  def stub_delete(path: '', status: 200)
    stub_endpoint(
      body: { 'deleted': true },
      method: :delete,
      path: path,
      status: status,
    )
  end

  private

  def file(filename)
    path = File.join(File.dirname(__FILE__), '../fixtures', "#{filename}.json")
    File.read(path)
  end

  def build_payload_from_fixture(values = nil)
    if values
      filename, override = if values.respond_to?(:keys)
                             [values[:name], values[:override]]
                           else
                             [values, {}]
                           end
      JSON.parse(file(filename)).merge!(override)
    end
  end
end
