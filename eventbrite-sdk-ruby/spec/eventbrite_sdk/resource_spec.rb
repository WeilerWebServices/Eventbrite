require 'spec_helper'

module EventbriteSDK
  RSpec.describe Resource do
    describe '#id' do
      it 'returns value when hydrated attributes contains id' do
        described_class.resource_path 'events/:id'

        resource = described_class.new('id' => '1234')

        expect(resource.id).to eq('1234')
      end

      it 'returns nil when hydrated attributes does not contain id' do
        described_class.resource_path 'events/:venue_id'

        resource = described_class.new('something' => '1234')

        expect(resource.venue_id).to be_nil
      end
    end

    describe '#new?' do
      it 'returns true when id is falsey' do
        described_class.resource_path 'events/:id'

        resource = described_class.new('something' => '1234')

        expect(resource).to be_new
      end

      it 'returns false when id is truthy' do
        described_class.resource_path 'events/:id'

        resource = described_class.new('id' => '1234')

        expect(resource).not_to be_new
      end
    end

    describe '#refresh!' do
      before do
        EventbriteSDK.token = 'token'
      end

      it 'resets memoized relationships' do
        dumdum_attrs = { id: 'dumdum2', name: { html: 'foo' } }
        event_attrs = {
          id: 'dummy1',
          dumdum: dumdum_attrs,
          dumdum_id: 'dumdum2'
        }
        updated_event_attrs = {
          id: 'dummy1',
          dumdum: dumdum_attrs.merge(name: { html: 'bar' }),
          dumdum_id: 'dumdum2'
        }
        dummy = DummyResource.new(event_attrs)

        # Stub the get request
        stub_get(
          path: 'events/dummy1',
          fixture: { name: :event_read, override: updated_event_attrs }
        )

        dummy.dumdum   # force the relative to be instantiated
        dummy.refresh! # trigger the reload, which should reset relationships

        # When accessed again, it should refresh the relative
        expect(dummy.dumdum.name.html).to eq('bar')
      end

      context 'when a id exists' do
        it 'reloads the instance from the return of the api' do
          stub_get(path: 'events/1', fixture: :event_read)

          event = DummyResource.new('id' => '1')

          event.assign_attributes 'name.html' => 'Foo'
          expect(event.name.html).to eq('Foo')

          event.refresh!

          expect(event.name.html).to eq('This is a test name')
        end
      end

      context 'when id is nil' do
        it 'returns false' do
          described_class.resource_path 'events/:id'

          resource = described_class.new('anything' => '1234')

          expect(resource.refresh!).to eq(false)
        end
      end
    end

    describe '#save' do
      before do
        EventbriteSDK.token = 'token'
      end

      it 'resets memoized relationships' do
        dumdum_attrs = { id: 'dumdum2', name: { html: 'foo' } }
        event_attrs = {
          id: 'dummy1',
          dumdum: dumdum_attrs,
          dumdum_id: 'dumdum2'
        }
        updated_event_attrs = {
          id: 'dummy1',
          dumdum: dumdum_attrs.merge(name: { html: 'bar' }),
          dumdum_id: 'dumdum2'
        }
        dummy = DummyResource.new(event_attrs)

        # Stub the save request
        stub_post(
          path: 'events/dummy1',
          fixture: { name: :event_created, override: updated_event_attrs }
        )

        allow(Dumdum).to receive(:new).and_call_original

        dummy.dumdum # force the relative to be instantiated
        dummy.assign_attributes('name.html' => 'foo')
        dummy.save   # trigger the save and reload, which should reset relationships

        # When accessed again, it should refresh the relative
        expect(dummy.dumdum.name.html).to eq('bar')
      end

      context 'with a new resource' do
        context 'when save is successful' do
          it 'sets the returned id, and resets changes' do
            name = "Test event #{SecureRandom.hex(4)}"

            described_class.resource_path 'events/:id'
            described_class.attributes_prefix 'event'
            allow(described_class).to receive(:schema).and_return(
              Resource::NullSchemaDefinition.new
            )

            stub_post(
              path: 'events',
              fixture: {
                name: :event_created,
                override: {
                  'id' => 'new',
                  'name' => {
                    'html' => name,
                  }
                }
              }
            )

            resource = described_class.build(
              'name.html' => name,
              'start.timezone' => 'America/Los_Angeles',
              'start.utc' => '2016-06-06T02:00:00Z',
              'end.timezone' => 'America/Los_Angeles',
              'end.utc' => '2016-07-06T02:00:00Z',
              'currency' => 'USD'
            )

            expect(resource.save).to eq(true)

            expect(resource.id).not_to be_nil
            expect(resource.name.html).to eq(name)
            expect(resource).not_to be_new
            expect(resource).not_to be_changed
          end
        end
      end

      context 'when a resource that has a id' do
        it 'rehydrates the instance with the response of the endpoint' do
          name = "Test event #{SecureRandom.hex(4)}"
          stub_get(
            path: 'events/111',
            fixture: { name: :event_read, override: { 'id' => '111' } }
          )
          stub_post(
            path: 'events/111',
            fixture: {
              name: :event_created,
              override: {
                'name' => {
                  'html' => name,
                  'text' => name
                }
              }
            }
          )
          event = DummyResource.retrieve(id: '111')

          event.assign_attributes('name.html' => name)

          event.save

          expect(event.name.html).to eq(name)
        end
      end

      context 'when given a postfix_path' do
        it 'passes it to endpoint_path' do
          described_class.resource_path 'events/:id'
          resource = described_class.new('id' => '1234')
          repo = double(post: { 'id' => '1234' })

          resource.save('postfix', request: repo)

          expect(repo).to have_received(:post).with(
            api_token: nil,
            url: 'events/1234/postfix',
            payload: {}
          )
        end
      end
    end

    describe '#list_class' do
      context 'when the given :symbol is a ResourceList' do
        it 'returns the constantized class' do
          expect(subject.list_class(:owned_event_orders)).
            to eq(Lists::OwnedEventOrdersList)
        end
      end

      context 'when the given :symbol does not match any valid ResourceList classes' do
        it 'returns ResourceList' do
          expect(subject.list_class(:nope)).to eq(ResourceList)
        end
      end
    end

    describe 'dynamic instance methods' do
      before do
        described_class.resource_path 'events/:id'
      end

      it 'should define new_method if included in define_api_actions' do
        resource = described_class.new('id' => '1')
        allow(EventbriteSDK).to receive(:post)

        expect do
          resource.new_method
        end.to raise_error(NoMethodError)

        described_class.define_api_actions :new_method

        resource.new_method

        expect(EventbriteSDK).
          to have_received(:post).
          with(url: 'events/1/new_method')
      end

      it 'should alias new_method if included in define_api_actions' do
        resource = described_class.new('id' => '1')
        allow(EventbriteSDK).to receive(:post)

        described_class.define_api_actions(new_method: :another_method_name)

        resource.new_method

        expect(EventbriteSDK).
          to have_received(:post).
          with(url: 'events/1/another_method_name')
      end
    end

    describe '#delete' do
      it 'deletes the resource and returns true' do
        described_class.resource_path 'events/:id'

        stub_delete(path: 'events/1234')

        resource = described_class.new('id' => '1234')

        expect(resource.delete).to eq(true)
      end
    end

    describe '#to_json' do
      subject { DummyResource.new }

      it 'delegates to @attributes' do
        options = {}
        allow(subject.attrs).to receive(:to_json).and_call_original

        subject.to_json(options)

        expect(subject.attrs).to have_received(:to_json).with(options)
      end
    end

    describe 'message expectations' do
      context 'with blank attributes' do
        subject { DummyResource.new }

        it 'a new instance of DummyResource responds to id returning nil' do
          expect(subject.id).to be_nil
        end

        it 'responds and returns nil on #name#html' do
          expect(subject.name.html).to be_nil
        end
      end
    end

    private

    class DummyResource < Resource
      resource_path 'events/:id'

      belongs_to :dumdum, object_class: 'Dumdum'

      attributes_prefix 'event'

      schema_definition do
        string 'name.html'
        string 'dumdum_id'
      end
    end

    class Dumdum < Resource
      resource_path 'dumdum/:id'

      attributes_prefix 'dumdum'

      schema_definition do
        string 'name.html'
      end
    end
  end
end
