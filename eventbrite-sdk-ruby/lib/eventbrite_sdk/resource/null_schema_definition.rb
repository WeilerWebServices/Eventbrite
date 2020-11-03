module EventbriteSDK
  class Resource
    class NullSchemaDefinition
      def writeable?(_key)
        true
      end

      def defined_keys
        []
      end

      def dirty_comparable(field)
        field.initial_value
      end
    end
  end
end
