module EventbriteSDK
  class Resource
    module Operations
      module List
        def list(query: {})
          ResourceList.new(
            key: path.split('/').first,
            object_class: EventbriteSDK.const_get(name.split('::').last),
            query: query,
            url_base: new.path.gsub(/\/\Z/, '')
          )
        end
      end
    end
  end
end
