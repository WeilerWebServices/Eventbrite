module EventbriteSDK
  class Resource
    class SchemaDefinition
      def initialize(resource_name)
        @attrs = {}
        @read_only_keys = Set.new
        @comparable = FieldComparable.new
        @resource_name = resource_name
      end

      %i[
        address
        boolean
        currency
        datetime
        integer
        multipart
        string
        utc
      ].each do |method|
        define_method(method) do |value, *opts|
          add_field_options(opts, value, method)
          add_field(opts, value, method)
        end
      end

      def writeable?(key)
        whitelisted_attribute?(key) && !read_only?(key)
      end

      def type(key)
        attrs[key]
      end

      def defined_keys
        attrs.keys
      end

      def dirty_comparable(field)
        comparable.value_for(attrs[field.key], field)
      end

      private

      attr_reader :comparable ,:read_only_keys, :resource_name, :attrs

      def add_field_options(opts, value, _method)
        options = opts.first
        @read_only_keys << value if options && options[:read_only]
      end

      def add_field(_options, value, method)
        @attrs[value] = method
        send(:"#{method}_expansion", value)
      end

      # The following fields are NO-OP expansions
      %i[boolean integer multipart string utc].each do |type|
        define_method("#{type}_expansion") { |val| }
      end

      def address_expansion(value)
        generic_expansion(
          %w[
            address_1
            address_2
            city
            country
            latitude
            localized_address_display
            localized_area_display
            longitude
            postal_code
            region
          ],
          value,
        )
      end

      def currency_expansion(value)
        generic_expansion(%w[currency display value], value)
      end

      def datetime_expansion(value)
        generic_expansion(%w[local utc timezone], value)
      end

      def multipart_expansion(value)
        generic_expansion(%i[html text], value)
      end

      def generic_expansion(types, value)
        types.map { |exp| @attrs["#{value}.#{exp}"] = :string }
      end

      def read_only?(key)
        read_only_keys.member?(key)
      end

      def whitelisted_attribute?(key)
        if attrs.has_key?(key)
          true
        else
          raise InvalidAttribute.new(
            "attribute `#{key}` not present in #{resource_name}"
          )
        end
      end
    end
  end
end
