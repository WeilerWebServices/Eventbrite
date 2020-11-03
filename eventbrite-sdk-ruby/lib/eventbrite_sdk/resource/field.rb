module EventbriteSDK
  class Resource
    class Field
      SIBLING_KEYMAP = { 'timezone' => 'utc', 'utc' => 'timezone' }.freeze
      SIBLING_REGEX = /\A(.+)\.(utc|timezone)\z/

      attr_reader :key, :value, :initial_value

      def initialize(key, value, prefix: nil, schema: NullSchemaDefinition.new)
        @key = (prefix && "#{prefix}.#{key}") || key
        @schema = schema
        @value = value
        @datetime = false
      end

      def changes(attrs, changes)
        %i[basic_changes rich_changes].reduce(changes) do |diff, method|
          send(method, attrs, diff)
        end
      end

      def keys
        key.split('.')
      end

      def writeable?
        schema.writeable?(key)
      end

      def apply(attrs, existing_changes)
        if writeable?
          changes(attrs, existing_changes).tap { bury(attrs) }
        else
          {}
        end
      end

      def bury(hash = {})
        nested_keys = keys
        # Hand rolling #bury, hopefully we get it in the next release of Ruby.
        # UPDATE: we won't https://bugs.ruby-lang.org/issues/11747
        nested_keys.each_cons(2).reduce(hash) do |prev_attrs, (nkey, _)|
          prev_attrs[nkey] ||= {}
        end[nested_keys.last] = value

        hash
      end

      private

      attr_reader :datetime, :schema

      def basic_changes(attrs, changes)
        @initial_value = attrs.dig(*keys)
        comp_value = schema.dirty_comparable(self)

        changes.merge(
          (comp_value != value && { key => [initial_value, value] }) || {}
        )
      end

      def rich_changes(attrs, changes)
        if key =~ SIBLING_REGEX && changes[key] && !changes[sister_field]
          @datetime = true
          changes.merge(sister_field => sister_change(attrs))
        else
          changes
        end
      end

      def sister
        if key =~ SIBLING_REGEX
          key_prefix = Regexp.last_match(1)
          sister_field = SIBLING_KEYMAP[Regexp.last_match(2)]

          [key_prefix, sister_field]
        end
      end

      def sister_field
        sister.join('.')
      end

      # Since we use dirty checking to determine what the payload is
      # you can run into a case where a "rich media" field needs other attrs
      # Namely timezone, so if a rich date changed, add the tz with it.
      def sister_change(attrs)
        Array.new(2) { attrs.dig(*sister) }
      end
    end
  end
end
