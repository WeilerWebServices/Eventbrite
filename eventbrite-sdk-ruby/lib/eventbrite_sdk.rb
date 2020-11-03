require 'json'
require 'set'
require 'rest_client'

require 'eventbrite_sdk/version'
require 'eventbrite_sdk/error_types'
require 'eventbrite_sdk/exceptions'
require 'eventbrite_sdk/resource/operations/attribute_schema'
require 'eventbrite_sdk/resource/operations/list'
require 'eventbrite_sdk/resource/operations/endpoint'
require 'eventbrite_sdk/resource/operations/relationships'
require 'eventbrite_sdk/resource/attributes'
require 'eventbrite_sdk/resource/null_schema_definition'
require 'eventbrite_sdk/resource/schema_definition'
require 'eventbrite_sdk/blank_resource_list'
require 'eventbrite_sdk/resource'
require 'eventbrite_sdk/resource/field'
require 'eventbrite_sdk/resource/field_comparable'
require 'eventbrite_sdk/resource_list'

require 'eventbrite_sdk/lists/owned_event_orders_list'

require 'eventbrite_sdk/attendee'
require 'eventbrite_sdk/category'
require 'eventbrite_sdk/discount'
require 'eventbrite_sdk/event'
require 'eventbrite_sdk/media'
require 'eventbrite_sdk/order'
require 'eventbrite_sdk/organization'
require 'eventbrite_sdk/organizer'
require 'eventbrite_sdk/report'
require 'eventbrite_sdk/subcategory'
require 'eventbrite_sdk/ticket_class'
require 'eventbrite_sdk/ticket_group'
require 'eventbrite_sdk/user'
require 'eventbrite_sdk/venue'
require 'eventbrite_sdk/webhook'
require 'eventbrite_sdk/organization_entities' # depends on Discount, Event, Venue

module EventbriteSDK
  BASE = "https://www.eventbriteapi.com/v#{VERSION.split('.').first}".freeze
  EXCEPTION_MAP = {
    RestClient::ResourceNotFound => {
      class: ResourceNotFound,
      message: 'requested object was not found'
    },
    RestClient::BadRequest => {
      class: BadRequest,
      message: 'invalid request'
    },
    RestClient::Forbidden => {
      class: Forbidden,
      message: 'not authorized'
    },
    RestClient::InternalServerError => {
      class: InternalServerError,
      message: 'internal server error'
    },
    RestClient::Unauthorized => {
      class: Unauthorized,
      message: 'unauthorized request'
    }
  }.freeze
  THREAD_EB_API_TOKEN_KEY = :eb_api_token
  VERIFY_SSL = true

  def self.token
    Thread.current[THREAD_EB_API_TOKEN_KEY]
  end

  def self.token=(api_token)
    Thread.current[THREAD_EB_API_TOKEN_KEY] = api_token
  end

  def self.base_url
    @base_url || BASE
  end

  def self.base_url=(url)
    @base_url = url
  end

  def self.verify_ssl?
    if @verify_ssl.nil?
      VERIFY_SSL
    else
      @verify_ssl
    end
  end

  def self.verify_ssl=(verifies)
    @verify_ssl = verifies
  end

  def self.get(params)
    params[:headers] = { 'Accept' => 'application/json' }
    params[:method] = :get

    request(params)
  end

  def self.post(params)
    params[:headers] = { 'Content-Type' => 'application/json' }
    params[:method] = :post

    # Don't convert nil to json.
    #
    # BadRequest is raised when you publish an event because the body sent is
    # "null" (invalid json) and the API rejects it.
    params[:payload] = params[:payload].to_json if params[:payload]

    request(params)
  end

  def self.delete(params)
    params[:headers] = { 'Accept' => 'application/json' }
    params[:method] = :delete

    request(params)
  end

  def self.request(params)
    req = format_request(params)
    req[:url] = url(params[:url].gsub(%r{\/$}, ''))
    req[:verify_ssl] = verify_ssl?

    response = RestClient::Request.execute(req)

    JSON.parse(response.body) unless response.body == ''
  rescue *EXCEPTION_MAP.keys => err
    handler = EXCEPTION_MAP[err.class]
    raise handler[:class].new(handler[:message], err.response)
  end

  def self.format_request(params)
    query = params.delete(:query)
    request_token = params.delete(:api_token)

    auth = request_token || token

    params[:headers]['Authorization'] = "Bearer #{auth}" if auth
    params[:headers][:params] = query if query

    params
  end

  def self.url(path)
    "#{base_url}/#{path}/"
  end
end
