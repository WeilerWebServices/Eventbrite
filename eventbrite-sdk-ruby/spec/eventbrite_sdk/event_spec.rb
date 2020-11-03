require 'spec_helper'

module EventbriteSDK
  RSpec.describe Event do
    before do
      EventbriteSDK.token = 'token'
    end

    describe 'errors' do
      it 'exposes the correct error types as constants' do
        expect(described_class::ERROR_CANNOT_UNPUBLISH).
          to eq('CANNOT_UNPUBLISH')
        expect(described_class::ERROR_ALREADY_PUBLISHED_OR_DELETED).
          to eq('ALREADY_PUBLISHED_OR_DELETED')
      end
    end

    describe '.retrieve' do
      context 'when found' do
        it 'returns a new instance' do
          stub_endpoint(
            path: 'events/1234',
            body: :event_read,
          )
          event = described_class.retrieve id: '1234'

          expect(event).to be_an_instance_of(described_class)
        end
      end

      context 'when not found' do
        it 'throws some sort of error' do
          stub_endpoint(
            path: 'events/10000',
            status: 404,
            body: :event_not_found,
          )

          expect { described_class.retrieve id: '10000' }.
            to raise_error('requested object was not found')
        end
      end
    end

    describe '.build' do
      it 'returns a hydrated instance' do
        event = described_class.build('name.html' => 'An Event')

        expect(event.name.html).to eq('An Event')
      end
    end

    describe '#changes' do
      it 'still sends utc event if only tz changed' do
        event = described_class.new(
          'start' => {
            'utc' => '2012-01-01', 'timezone' => 'America/Los_Angeles'
          }
        )

        event.assign_attributes(
          'start.timezone' => 'America/Chicago',
          'start.utc' => '2012-01-01'
        )

        expect(event.changes).to match(
          'start.utc' => ['2012-01-01', '2012-01-01'],
          'start.timezone' => ['America/Los_Angeles', 'America/Chicago']
        )
      end

      it 'still sends utc event if only TZ changed, order does not matter' do
        event = described_class.new(
          'start' => {
            'utc' => '2012-01-01', 'timezone' => 'America/Los_Angeles'
          }
        )

        event.assign_attributes(
          'start.utc' => '2012-01-01',
          'start.timezone' => 'America/Chicago'
        )

        expect(event.changes).to match(
          'start.utc' => ['2012-01-01', '2012-01-01'],
          'start.timezone' => ['America/Los_Angeles', 'America/Chicago']
        )
      end

      it 'auto dirties TZ when you touch an attribute that ends in "utc"' do
        event = described_class.new(
          'start' => {
            'utc' => '2012-01-01', 'timezone' => 'America/Los_Angeles'
          }
        )

        event.assign_attributes('start.utc' => '9999-99-99')

        expect(event.changes).to match(
          'start.utc' => ['2012-01-01', '9999-99-99'],
          'start.timezone' => ['America/Los_Angeles', 'America/Los_Angeles']
        )
      end

      it 'does not auto override if you are actually changing tz' do
        event = described_class.new(
          'start' => {
            'utc' => '2012-01-01', 'timezone' => 'America/Los_Angeles'
          }
        )

        event.assign_attributes(
          'start.utc' => '9999-99-99',
          'start.timezone' => 'America/Chicago'
        )

        expect(event.changes).to match(
          'start.utc' => ['2012-01-01', '9999-99-99'],
          'start.timezone' => ['America/Los_Angeles', 'America/Chicago']
        )
      end

      it 'does not change when given an existing utc value' do
        same_date = '2012-01-01'
        event = described_class.new(
          'start' => {
            'utc' => same_date,
            'timezone' => 'America/Los_Angeles'
          }
        )

        event.assign_attributes('start.utc' => same_date)

        expect(event).not_to be_changed
      end

      it 'does not change when given existing timezone value' do
        same_tz = 'America/Los_Angeles'
        event = described_class.new(
          'start' => {
            'utc' => '2012-01-01',
            'timezone' => same_tz
          }
        )

        event.assign_attributes('start.timezone' => same_tz)

        expect(event).not_to be_changed
      end

      it 'does not change when gevn existing tz/utc values' do
        same_tz = 'America/Los_Angeles'
        same_utc = '2012-01-01'

        event = described_class.new(
          'start' => {
            'timezone' => same_tz,
            'utc' => same_utc
          }
        )

        event.assign_attributes(
          'start.timezone' => same_tz,
          'start.utc' => same_utc
        )

        expect(event).not_to be_changed
      end
    end

    describe '#cancel' do
      context 'when id exists' do
        it 'calls save with `cancel`' do
          event = described_class.new('id' => '1')
          allow(EventbriteSDK).to receive(:post).and_return('bahleted')

          result = event.cancel

          expect(result).to eq('bahleted')
          expect(EventbriteSDK).to have_received(:post).with(
            url: 'events/1/cancel'
          )
        end

        it 'when given :api_token it passes it through' do
          event = described_class.new('id' => '1')
          allow(EventbriteSDK).to receive(:post).and_return('bahleted')

          result = event.cancel(api_token: 'api_token')

          expect(result).to eq('bahleted')
          expect(EventbriteSDK).to have_received(:post).with(
            url: 'events/1/cancel', api_token: 'api_token'
          )
        end
      end

      context 'when id is absent' do
        it 'returns false' do
          event = described_class.new

          expect(event.cancel).to eq(false)
        end
      end
    end

    describe '#list!' do
      context 'when event is not listed' do
        it 'sets listed to true and calls #save' do
          event = described_class.new('id' => '1', 'listed' => false)

          allow(event).to receive(:save)

          event.list!

          expect(event).to have_received(:save)
          expect(event.listed).to eq(true)
        end
      end

      context 'when event is already listed' do
        it 'does not change listed and does not call #save' do
          event = described_class.new('id' => '1', 'listed' => true)

          allow(event).to receive(:save)

          event.list!

          expect(event).not_to have_received(:save)
          expect(event.listed).to eq(true)
        end
      end
    end

    describe '#orders' do
      context 'when event is new' do
        it 'instantiates a BlankResourceList' do
          expect(subject.orders).to be_an_instance_of(BlankResourceList)
          expect(subject.orders).to be_empty
        end
      end

      context 'when event exists' do
        it 'hydrates a list of Orders' do
          stub_get(
            path: 'events/31337',
            fixture: {
              name: :event_read,
              override: { 'id' => '31337' }
            }
          )
          stub_get(path: 'events/31337/orders', fixture: :event_orders)

          event = described_class.retrieve(id: '31337')

          event.orders.retrieve

          expect(event.orders).to be_an_instance_of(ResourceList)
          expect(event.orders.first).to be_an_instance_of(Order)
        end
      end
    end

    describe '#attendees' do
      context 'when event is new' do
        it 'instantiates a BlankResourceList' do
          expect(subject.attendees).to be_an_instance_of(BlankResourceList)
          expect(subject.attendees).to be_empty
        end
      end

      context 'when event exists' do
        it 'hydrates a list of Attendees' do
          stub_get(
            path: 'events/31337',
            fixture: {
              name: :event_read,
              override: { 'id' => '31337' }
            }
          )
          stub_get(path: 'events/31337/attendees', fixture: :attendees_read)

          event = described_class.retrieve(id: '31337')

          event.attendees.retrieve

          expect(event.attendees).to be_an_instance_of(ResourceList)
          expect(event.attendees.first).to be_an_instance_of(Attendee)
        end
      end
    end

    describe '#ticket_classes' do
      context 'when event is new' do
        it 'instantiates a BlankResourceList' do
          expect(subject.ticket_classes).to be_an_instance_of(BlankResourceList)
          expect(subject.ticket_classes).to be_empty
        end
      end

      context 'when event exists' do
        it 'hydrates a list of TicketClasses' do
          stub_get(
            path: 'events/31337',
            fixture: {
              name: :event_read,
              override: { 'id' => '31337' }
            }
          )
          stub_get(
            path: 'events/31337/ticket_classes',
            fixture: :event_ticket_classes
          )

          event = described_class.retrieve(id: '31337')
          event.ticket_classes.retrieve

          expect(event.ticket_classes).to be_an_instance_of(ResourceList)
          expect(event.ticket_classes.first).to be_an_instance_of(TicketClass)
        end
      end
    end

    describe '#publish' do
      context 'when id exists' do
        it 'calls save with the called method name' do
          event = described_class.new('id' => '1')
          allow(EventbriteSDK).to receive(:post).and_return('published')

          result = event.publish

          expect(result).to eq('published')
          allow(EventbriteSDK).to receive(:post).and_return('published')
        end
      end

      context 'when id is absent' do
        it 'returns false' do
          event = described_class.new
          allow(event).to receive(:save)

          expect(event.publish).to eq(false)
        end
      end
    end

    describe '#unlist!' do
      context 'when event is not listed' do
        it 'does not change listed and does not call save' do
          event = described_class.new('id' => '1', 'listed' => false)

          allow(event).to receive(:save)

          event.unlist!

          expect(event).not_to have_received(:save)
          expect(event.listed).to eq(false)
        end
      end

      context 'when event is already listed' do
        it 'sets listed to false and calls #save' do
          event = described_class.new('id' => '1', 'listed' => true)

          allow(event).to receive(:save)

          event.unlist!

          expect(event).to have_received(:save)
          expect(event.listed).to eq(false)
        end
      end
    end

    describe '#unpublish' do
      context 'when id exists' do
        it 'calls save with the called method name' do
          event = described_class.new('id' => '1')
          allow(EventbriteSDK).to receive(:post).and_return('unpublish')

          result = event.unpublish

          expect(result).to eq('unpublish')
          expect(EventbriteSDK).to have_received(:post).with(
            url: 'events/1/unpublish'
          )
        end
      end

      context 'when id is absent' do
        it 'returns false' do
          event = described_class.new
          allow(event).to receive(:save)

          expect(event.unpublish).to eq(false)
        end
      end
    end

    describe '#over?' do
      context 'when status is canceled' do
         it 'returns true' do
           status = described_class::STATUS_CANCELED
           subject = described_class.new(status: status)

           expect(subject).to be_over
         end
       end

       context 'when status is completed' do
         it 'returns true' do
           status = described_class::STATUS_COMPLETED
           subject = described_class.new(status: status)

           expect(subject).to be_over
         end
       end

       context 'when status is deleted' do
         it 'returns true' do
           status = described_class::STATUS_DELETED
           subject = described_class.new(status: status)

           expect(subject).to be_over
         end
       end

       context 'when status is ended' do
         it 'returns true' do
           status = described_class::STATUS_ENDED
           subject = described_class.new(status: status)

           p subject.status
           expect(subject).to be_over
         end
       end

       context 'when status is live' do
         it 'returns false' do
           status = described_class::STATUS_LIVE
           subject = described_class.new(status: status)

           expect(subject).not_to be_over
         end
       end

       context 'when status is started' do
         it 'returns false' do
           status = described_class::STATUS_STARTED
           subject = described_class.new(status: status)

          expect(subject).not_to be_over
        end
      end

      context 'when status is nil' do
        it 'returns false' do
          expect(subject).not_to be_over
        end
      end
    end

    describe '#ticket_groups' do
      it 'returns a new Resource list with a proper url_base' do
        allow(ResourceList).to receive(:new)

        described_class.new(id: '1').ticket_groups

        expect(ResourceList).
          to have_received(:new).
          with(
            url_base: 'events/1/ticket_groups',
             object_class: TicketGroup,
             key: :ticket_groups
           )
      end
    end
  end
end
