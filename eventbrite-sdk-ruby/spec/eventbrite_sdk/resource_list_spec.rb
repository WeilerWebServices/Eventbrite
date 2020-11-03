require 'spec_helper'

module EventbriteSDK
  RSpec.describe ResourceList do
    describe '#empty?' do
      it 'returns true' do
        expect(described_class.new(url_base: 'orders', object_class: Order)).
          to be_empty
      end
    end

    describe '#concat' do
      it 'calls given object#concat with self#to_ary' do
        payload = { 'events' => [ { 'id' => '1' } ] }

        request = double('Request', get: payload)

        list = described_class.new(
          url_base: 'url',
          object_class: Event,
          key: :events,
          request: request
        )

        list.retrieve

        expect(list.concat([1])).to eq([1] + list.to_ary)
      end
    end

    describe '#retrieve' do
      context 'when query is set on initialization' do
        it 'calls request with query' do
          api_token = 'api_token'
          request = double('Request', get: {})

          described_class.
            new(request: request, query: { event_id: 1 }).
            retrieve(api_token: api_token)

          expect(request).to have_received(:get).with(
            url: nil,
            query: { event_id: 1 },
            api_token: api_token
          )
        end
      end

      context 'when @expansion is set' do
        it 'calls request with an expansion query' do
          request = double('Request', get: {})

          list = described_class.new(request: request)

          list.with_expansion('organizer', :event, 'event.venue').retrieve

          expect(request).to have_received(:get).with(
            url: nil,
            query: { expand: 'organizer,event,event.venue' },
            api_token: nil
          )
        end

        context 'when another page is requested' do
          it 'continues to paginate with the original expansion' do
            payload = {
              'pagination' => { 'page_number' => 1, 'page_count' => 2 }
            }
            request = double('Request', get: payload)

            list = described_class.new(request: request)

            list.with_expansion('organizer', :event, 'event.venue').retrieve

            list.next_page

            expect(request).to have_received(:get).with(
              url: nil,
              query: { page: 2, expand: 'organizer,event,event.venue' },
              api_token: nil
            )
          end
        end
      end

      context 'when the request payload contains the key given' do
        it 'hydrates objects within a given key with then given object_class' do
          payload = {
            'events' => [
              { 'id' => '1' },
              { 'id' => '2' },
              { 'id' => '3' }
            ]
          }

          request = double('Request', get: payload)

          list = described_class.new(
            url_base: 'url',
            object_class: Event,
            key: :events,
            request: request
          )

          list.retrieve

          expect(request).to have_received(:get).with(
            url: 'url', query: {}, api_token: nil
          )
          expect(list.first).to be_an_instance_of(Event)

          expect(list[0].id).to eq('1')
          expect(list[1].id).to eq('2')
          expect(list[2].id).to eq('3')
        end
      end

      context 'when the request payload does not contain key given' do
        it 'hydrates objects within a given key with given object_class' do
          payload = {
            'nope' => [
              { 'id' => '1' },
              { 'id' => '2' },
              { 'id' => '3' }
            ]
          }

          request = double('Request', get: payload)

          list = described_class.new(
            url_base: 'url',
            object_class: Event,
            key: :events,
            request: request,
          )

          list.retrieve

          expect(request).to have_received(:get).with(
            url: 'url', query: {}, api_token: nil
          )
          expect(list).to be_empty
        end
      end

      context 'when :query is given' do
        it 'merges the given values with what was given during instantiation' do
          request = double('Request', get: {})
          list = described_class.new(
            query: { test: 'foo' },
            request: request,
            url_base: 'testbase'
          )

          list.retrieve(query: { sun: 'glasses' })

          expect(request).to have_received(:get).with(
            url: 'testbase',
            query: {
              sun: 'glasses',
              test: 'foo',
            },
            api_token: nil
          )
        end

        context 'and :page is given in the query' do
          it 'overrides the current page' do
            request = double('Request', get: {})
            list = described_class.new(
              query: { test: 'foo' },
              request: request,
              url_base: 'testbase'
            )

            list.retrieve(query: { page: 100, sun: 'glasses' })

            expect(request).to have_received(:get).with(
              url: 'testbase',
              query: {
                test: 'foo',
                page: 100,
                sun: 'glasses'
              },
              api_token: nil
            )
          end
        end

        context 'and #next_page is called after the initial custom query' do
          it 'requests the next page with the custom :query values' do
            request = double(
              'Request',
              get: {
                'pagination' => {
                  'page_number' => 1,
                  'page_count' => 2
                }
              }
            )
            list = described_class.new(
              query: { test: 'foo' },
              request: request,
              url_base: 'testbase'
            )

            list.retrieve(query: { sun: 'glasses' })

            expect(request).to have_received(:get).with(
              url: 'testbase',
              query: {
                test: 'foo',
                sun: 'glasses'
              },
              api_token: nil
            )

            list.next_page

            expect(request).to have_received(:get).with(
              url: 'testbase',
              query: {
                test: 'foo',
                page: 2,
                sun: 'glasses'
              },
              api_token: nil
            )
          end
        end
      end
    end

    context 'continuation' do
      it 'retrieves using the retrieved continuation token' do
        payload = {
          'events' => [
          ],
          'pagination' => {
            'continuation' => 'abc',
            'has_more_items' => true,
          }
        }

        request = double('Request', get: payload)

        list = described_class.new(
          url_base: 'url',
          object_class: Event,
          key: :events,
          request: request,
        )

        list.retrieve

        list.continue

        expect(request).to have_received(:get).with(
          url: 'url', query: { continuation: 'abc' }, api_token: nil
        )
      end

      it 'retrieves using given optional continuation_token' do
        payload = {
          'events' => [
          ],
          'pagination' => {
            'continuation' => 'abc',
            'has_more_items' => true,
          }
        }

        request = double('Request', get: payload)

        list = described_class.new(
          url_base: 'url',
          object_class: Event,
          key: :events,
          request: request,
        )

        list.retrieve

        list.continue(continuation_token: 'not_abc')

        expect(request).to have_received(:get).with(
          url: 'url', query: { continuation: 'not_abc' }, api_token: nil
        )
      end

      it 'returns nil when hydrated result has_more_items=false and continuation not present' do
        payload = {
          'events' => [
          ],
          'pagination' => {
            'has_more_items' => false,
          }
        }

        request = double('Request', get: payload)

        list = described_class.new(
          url_base: 'url',
          object_class: Event,
          key: :events,
          request: request,
        )

        list.retrieve

        expect(list.continue).to be_nil
      end
    end

    context 'pagination' do
      it 'returns the value provided in the requests `pagination` payload' do
        pagination = {
          'pagination' => {
            'continuation' => 'abc',
            'has_more_items' => true,
            'object_count' => 13,
            'page_number' => 2,
            'page_size' => 50,
            'page_count' => 2,
          }
        }

        request = double('Request', get: pagination)

        list = described_class.new(
          url_base: 'url',
          object_class: Event,
          key: :events,
          request: request,
        )

        list.retrieve

        expect(list.continuation).to eq('abc')
        expect(list.has_more_items).to eq(true)
        expect(list.object_count).to eq(13)
        expect(list.page_number).to eq(2)
        expect(list.page_size).to eq(50)
        expect(list.page_count).to eq(2)
      end

      it 'retrieves page number when calling #page' do
        payload = {
          'events' => [
            { 'id' => '1' },
            { 'id' => '2' },
            { 'id' => '3' },
          ]
        }

        request = double('Request', get: payload)

        list = described_class.new(
          url_base: 'url',
          object_class: Event,
          key: :events,
          request: request,
        )

        allow(list).to receive(:page=)

        list.page(2)

        expect(request).to have_received(:get).with(
          url: 'url', query: { page: 2 }, api_token: nil
        )
      end

      it 'retrieves next page when calling #next_page' do
        page_number = 1
        pagination = {
          'pagination' => {
            'object_count' => 130,
            'page_number' => page_number,
            'page_size' => 50,
            'page_count' => 2,
          }
        }

        request = double('Request', get: pagination.dup)

        list = described_class.new(
          url_base: 'url',
          object_class: Event,
          key: :events,
          request: request,
        )

        list.retrieve
        list.next_page

        expect(request).to have_received(:get).with(
          api_token: nil,
          query: {},
          url: 'url',
        )
        expect(request).to have_received(:get).with(
          url: 'url',
          query: { page: page_number + 1 },
          api_token: nil
        )
      end

      it 'retrieves previous page when calling #prev_page' do
        page_number = 2
        pagination = {
          'pagination' => {
            'object_count' => 130,
            'page_number' => page_number,
            'page_size' => 50,
            'page_count' => 2,
          }
        }

        request = double('Request', get: pagination.dup)

        list = described_class.new(
          url_base: 'url',
          object_class: Event,
          key: :events,
          request: request
        )

        list.page(2)
        list.prev_page

        expect(request).to have_received(:get).with(
          url: 'url',
          query: { page: page_number },
          api_token: nil
        )
        expect(request).to have_received(:get).with(
          url: 'url',
          query: { page: page_number - 1 },
          api_token: nil
        )
      end
    end

    describe '#to_json' do
      it 'returns a JSON list of objects hydrated with defined schema' do
        payload = {
          'events' => [
            { 'id' => '1' },
            { 'id' => '2' },
            { 'id' => '3' }
          ],
          'pagination' => {
            'object_count' => 3,
            'page_number' => 1,
            'page_size' => 50,
            'page_count' => 1
          }
        }

        request = double('Request', get: payload)

        list = described_class.new(
          url_base: 'url',
          object_class: Event,
          key: :events,
          request: request
        )

        list.retrieve

        list_json = JSON.parse(list.to_json)

        expect(list_json).to eq(
          'events' => [
            {
              'name' => { 'html' => nil, 'text' => nil },
              'description' => { 'html' => nil, 'text' => nil },
              'organizer_id' => nil,
              'start' => { 'local' => nil, 'timezone' => nil, 'utc' => nil },
              'end' => { 'local' => nil, 'timezone' => nil, 'utc' => nil },
              'hide_start_date' => nil,
              'hide_end_date' => nil,
              'currency' => nil,
              'venue_id' => nil,
              'online_event' => nil,
              'listed' => nil,
              'logo_id' => nil,
              'category_id' => nil,
              'subcategory_id' => nil,
              'format_id' => nil,
              'shareable' => nil,
              'invite_only' => nil,
              'password' => nil,
              'capacity' => nil,
              'show_remaining' => nil,
              'source' => nil,
              'status' => nil,
              'created' => nil,
              'changed' => nil,
              'resource_uri' => nil,
              'id' => '1'
            },
            {
              'name' => { 'html' => nil, 'text' => nil },
              'description' => { 'html' => nil, 'text' => nil },
              'organizer_id' => nil,
              'start' => { 'local' => nil, 'timezone' => nil, 'utc' => nil },
              'end' => { 'local' => nil, 'timezone' => nil, 'utc' => nil },
              'hide_start_date' => nil,
              'hide_end_date' => nil,
              'currency' => nil,
              'venue_id' => nil,
              'online_event' => nil,
              'listed' => nil,
              'logo_id' => nil,
              'category_id' => nil,
              'subcategory_id' => nil,
              'format_id' => nil,
              'shareable' => nil,
              'invite_only' => nil,
              'password' => nil,
              'capacity' => nil,
              'show_remaining' => nil,
              'source' => nil,
              'status' => nil,
              'created' => nil,
              'changed' => nil,
              'resource_uri' => nil,
              'id' => '2'
            },
            {
              'name' => { 'html' => nil, 'text' => nil },
              'description' => { 'html' => nil, 'text' => nil },
              'organizer_id' => nil,
              'start' => { 'local' => nil, 'timezone' => nil, 'utc' => nil },
              'end' => { 'local' => nil, 'timezone' => nil, 'utc' => nil },
              'hide_start_date' => nil,
              'hide_end_date' => nil,
              'currency' => nil,
              'venue_id' => nil,
              'online_event' => nil,
              'listed' => nil,
              'logo_id' => nil,
              'category_id' => nil,
              'subcategory_id' => nil,
              'format_id' => nil,
              'shareable' => nil,
              'invite_only' => nil,
              'password' => nil,
              'capacity' => nil,
              'show_remaining' => nil,
              'source' => nil,
              'status' => nil,
              'created' => nil,
              'changed' => nil,
              'resource_uri' => nil,
              'id' => '3'
            }
          ],
          'pagination' => {
            'object_count' => 3,
            'page_number' => 1,
            'page_size' => 50,
            'page_count' => 1
          }
        )
      end
    end
  end
end
