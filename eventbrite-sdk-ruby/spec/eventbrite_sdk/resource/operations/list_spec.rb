require 'spec_helper'

module EventbriteSDK
  class Resource
    module Operations
      RSpec.describe List do
        describe '.list' do
          it 'passes given query to new ResourceList instance' do
            list = instance_double(ResourceList)
            class MyResource
              extend EventbriteSDK::Resource::Operations::List

              def self.path
                'object/object'
              end

              def path
                self.class.path
              end

              def self.name
                'a::Event'
              end
            end

            allow(ResourceList).to receive(:new).and_return(list)

            MyResource.list(query: { test: 'test' })

            expect(ResourceList).to have_received(:new).with(
              key: MyResource.path.split('/').first,
              object_class: EventbriteSDK::Event,
              query: { test: 'test' },
              url_base: MyResource.path
            )
          end
        end
      end
    end
  end
end
