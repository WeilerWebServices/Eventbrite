module EventbriteSDK
  class Resource
    class Attributes
      attr_reader :attrs, :changes

      def self.build(attrs, schema)
        new({}, schema).tap do |instance|
          instance.assign_attributes(attrs)
        end
      end

      def initialize(hydrated_attrs = {}, schema = NullSchemaDefinition.new)
        @changes = {}
        @schema = schema

        # Build out initial hash based on schema's defined keys
        @attrs = schema.defined_keys.each_with_object({}) do |key, attrs|
          Field.new(key, nil).bury(attrs)
        end.merge(stringify_keys(hydrated_attrs))
      end

      def [](key)
        public_send(key)
      end

      def assign_attributes(new_attrs)
        stringify_keys(new_attrs).each do |attribute_key, value|
          value = Field.new(attribute_key, value, schema: schema)
          changes.merge! value.apply(attrs, changes)
        end

        nil
      end

      def changed?
        changes.any?
      end

      def to_h
        attrs.to_h
      end

      def to_json(opts = {})
        to_h.to_json(opts)
      end

      def inspect
        "#<#{self.class}: #{JSON.pretty_generate(@attrs.to_h)}>"
      end

      def reset!
        changes.each do |attribute_key, (old_value, _current_value)|
          Field.new(attribute_key, old_value).bury(attrs)
        end

        @changes = {}

        true
      end

      # Provides changeset in a format that can be thrown at an endpoint
      #
      # prefix: This is needed due to inconsistencies in the EB API
      #         Sometimes there's a prefix, sometimes there's not,
      #         sometimes it's singular, sometimes it's plural.
      #         Once the API gets a bit more normalized we can remove this
      #         altogether and infer a prefix based
      #         on the class name of the resource
      def payload(prefix = nil)
        changes.each_with_object({}) do |(attribute_key, (_, value)), payload|
          Field.new(attribute_key, value, prefix: prefix).bury(payload)
        end
      end

      def values
        attrs.values
      end

      private

      attr_reader :schema

      def method_missing(method_name, *_args, &_block)
        requested_key = method_name.to_s

        if attrs.key?(requested_key)
          handle_requested_attr(attrs[requested_key])
        else
          super
        end
      end

      def respond_to_missing?(method_name, _include_private = false)
        attrs.key?(method_name.to_s) || super
      end

      def handle_requested_attr(value)
        if value.is_a?(Hash)
          self.class.new(value)
        else
          value
        end
      end

      def stringify_keys(params)
        params.to_h.map { |key, value| [key.to_s, value] }.to_h
      end
    end
  end
end
