require 'spec_helper'

module EventbriteSDK
  module Lists
    RSpec.describe OwnedEventOrdersList do
      describe '#search' do
        context 'when given a truthy value' do
          it 'calls request /w modified url_base with given search_term' do
            request = double(get: { 'key' => [] })
            list = described_class.new(
              url_base: 'users/me/owned_event_orders',
              request: request
            )

            list.search('term').retrieve

            expect(request).to have_received(:get).with(
              api_token: nil,
              query: { search_term: 'term' },
              url: 'users/me/search_owned_event_orders',
            )
          end
        end

        context 'when given a falsey value' do
          it 'calls request /w original url_base ' do
            request = double(get: { 'key' => [] })
            list = described_class.new(
              url_base: 'users/me/owned_event_orders',
              request: request
            )

            list.search(false).retrieve

            expect(request).to have_received(:get).with(
              api_token: nil,
              query: {},
              url: 'users/me/owned_event_orders',
            )
          end
        end
      end
    end
  end
end
