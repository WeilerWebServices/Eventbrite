module EventbriteSDK
  class Resource
    include Operations::AttributeSchema
    include Operations::Endpoint
    include Operations::Relationships

    def self.build(attrs)
      new.tap do |instance|
        instance.assign_attributes(attrs)
      end
    end

    # Allows compile time definition of POST methods
    #
    # Example:
    #   class Event < Resource
    #     define_api_actions :publish, :unpublish
    #   end
    #
    # would defined instance methods like so:
    #
    # def publish
    #   !new? && EventbriteSDK.post(url: path('publish'))
    # end
    #
    # def publish
    #   !new? && EventbriteSDK.post(url: path('unpublish'))
    # end
    def self.define_api_actions(*actions)
      req = lambda do |inst, postfix, opts|
        inst.instance_eval { !new? && EventbriteSDK.post(opts.merge(url: path(postfix))) }
      end

      actions.each do |action|
        if action.is_a?(Hash)
          method_name, postfix_path = action.flatten
        else
          method_name = postfix_path = action
        end

        define_method(method_name) { |opts = {}| req.call(self, postfix_path, opts) }
      end
    end

    def initialize(hydrated_attrs = {})
      reload hydrated_attrs
    end

    def new?
      !id
    end

    def refresh!(request: EventbriteSDK, api_token: nil)
      if new?
        false
      else
        reload request.get(url: path, api_token: api_token)
      end
    end

    def inspect
      "#<#{self.class}: #{JSON.pretty_generate(@attrs.to_h)}>"
    end

    def save(postfixed_path = '', api_token: nil, request: EventbriteSDK)
      return unless changed? || !postfixed_path.empty?

      response = request.post(url: path(postfixed_path),
                              payload: attrs.payload(self.class.prefix),
                              api_token: api_token)

      reload(response)

      true
    end

    def to_json(opts = {})
      attrs.to_json(opts)
    end

    def delete(request: EventbriteSDK, api_token: nil)
      request.delete(url: path, api_token: api_token)['deleted']
    end

    def read_attribute_for_serialization(attribute)
      attrs[attribute]
    end

    private

    def resource_class_from_string(klass)
      EventbriteSDK.const_get(klass)
    end

    def reload(hydrated_attrs = {})
      build_attrs(hydrated_attrs)
      reset_memoized_relationships
    end
  end
end
