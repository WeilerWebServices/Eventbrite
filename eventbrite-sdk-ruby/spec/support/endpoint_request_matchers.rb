#
# This is a light wrapper on WebMocks api to support a few things
# 1) Only need to pass the path rather than a full URL
# 2) Easily add the api token in the #with requirement
# 3) By syntactically light
#
# IE)
#
# expect(api_path).to have_received_request(:post)
#
# expect(api_path).
#   to have_received_request(:post).
#   with(body: { event: <some_event_attrs> })
#
# You can even test the token to be sure it was included.
#
# expect(api_path).to have_received_request(:post).with(
#   api_token: 'abc',
#   body: { event: <some_event_attrs> }
# )
#
RSpec::Matchers.define :have_received_request do |method|
  match do |path|
    @webmock_matcher = WebMock::WebMockMatcher.new(
      method, "https://www.eventbriteapi.com/v3/#{path}/"
    )

    @webmock_matcher.with(@request_params) if @request_params

    @webmock_matcher.matches?(WebMock)
  end

  failure_message do |actual|
    @webmock_matcher.failure_message
  end

  failure_message_when_negated do |actual|
    @webmock_matcher.failure_message_when_negated
  end

  chain :with do |params|
    # Called prior to #match
    if token = params.delete(:api_token)
      params[:headers] = { 'Authorization' => "Bearer #{token}" }
    end

    @request_params = params
  end
end

RSpec::Matchers.define :have_received_get do |method|
  match do |path|
    @webmock_get_matcher = WebMock::WebMockMatcher.new(
      method, "https://www.eventbriteapi.com/v3/#{path}"
    )

    @webmock_get_matcher.matches?(WebMock)
  end

  failure_message do |actual|
    @webmock_get_matcher.failure_message
  end

  failure_message_when_negated do |actual|
    @webmock_get_matcher.failure_message_when_negated
  end
end
