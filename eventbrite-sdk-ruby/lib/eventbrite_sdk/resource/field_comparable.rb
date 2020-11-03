module EventbriteSDK
  class Resource
    class FieldComparable
      def value_for(type, field)
        if type == :currency && field.initial_value
          field.initial_value.values_at(:currency, :value).join(',')
        else
          field.initial_value
        end
      end
    end
  end
end
