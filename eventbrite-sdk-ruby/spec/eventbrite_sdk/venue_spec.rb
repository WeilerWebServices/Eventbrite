require 'spec_helper'

module EventbriteSDK
  RSpec.describe Venue do
    before do
      EventbriteSDK.token = 'token'
    end

    describe '.retrieve' do
      context 'when found' do
        it 'returns a new instance' do
          stub_get(
            body: { id: '1234', name: 'foo' },
            path: 'venues/1234',
          )
          subject = described_class.retrieve(id: '1234')

          expect(subject).to be_an_instance_of(described_class)
          expect(subject.id).to eq('1234')
          expect(subject.name).to eq('foo')
        end
      end

      context 'when not found' do
        it 'throws an sort of error' do
          stub_get(
            path: 'venues/10000',
            status: 404,
          )

          expect { described_class.retrieve(id: '10000') }.
            to raise_error('requested object was not found')
        end
      end
    end

    describe '.build' do
      it 'returns a hydrated instance' do
        subject = described_class.build('name' => 'Venue McVenueface')

        expect(subject.name).to eq('Venue McVenueface')
      end
    end

    describe '#save' do
      it 'posts to the correct endpoint with the given attributes' do
        stub_post(
          body: { id: '123' },
          path: 'venues/123',
        )

        attrs = {
          'address.address_1' => '120 K St.',
          'address.address_2' => 'second floor',
          'address.city' => 'Sacramento',
          'address.country' => 'US',
          'address.latitude' => '100.0',
          'address.localized_address_display' => 'local1',
          'address.localized_area_display' => 'local2',
          'address.longitude' => '200.0',
          'address.postal_code' => '95843',
          'address.region' => 'CA',
          'age_restriction' => '18+',
          'capacity' => 1000,
          'latitude' => 'ima lat',
          'longitude' => 'well ima lon',
          'name' => 'Old Building',
        }
        subject = described_class.new(id: '123')
        subject.assign_attributes(attrs)

        result = subject.save()

        expect(result).to eq(true)

        expect('venues/123').to have_received_request(:post).with(
          body: {
            venue: {
              address: {
                address_1: '120 K St.',
                address_2: 'second floor',
                city: 'Sacramento',
                country: 'US',
                latitude: '100.0',
                localized_address_display: 'local1',
                localized_area_display: 'local2',
                longitude: '200.0',
                postal_code: '95843',
                region: 'CA',
              },
              age_restriction: '18+',
              capacity: 1000,
              latitude: 'ima lat',
              longitude: 'well ima lon',
              name: 'Old Building',
            },
          },
        )
      end
    end
  end
end
