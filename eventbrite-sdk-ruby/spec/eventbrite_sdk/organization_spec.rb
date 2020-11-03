require 'erb'
require 'spec_helper'

include ERB::Util

module EventbriteSDK
  RSpec.describe Organization do
    describe '#discounts' do
      it 'returns a ResourceList hydrated with the correct path' do
        org = described_class.new(id: 'id')

        stub_get(
          path: "organizations/#{org.id}/discounts/?page=2",
          body: {
            discounts: [{ id: 'd' }]
          }
        )

        list = org.discounts.page(2)

        expect(list.first.id).to eq('d')
      end
    end

    describe '#events' do
      it 'returns a ResourceList hydrated with the correct path' do
        org = described_class.new(id: 'id')

        stub_get(
          path: "organizations/#{org.id}/events/?page=1",
          body: {
            events: [{ id: 'e' }]
          }
        )

        list = org.events.page(1)

        expect(list.first.id).to eq('e')
      end
    end

    describe '#orders' do
      it 'returns a ResourceList hydrated with the correct path' do
        org = described_class.new(id: 'id')

        stub_get(
          path: "organizations/#{org.id}/orders/?page=1",
          body: {
            orders: [{ id: 'o' }]
          }
        )

        list = org.orders.page(1)

        expect(list.first.id).to eq('o')
      end
    end

    describe '#organizers' do
      it 'returns a ResourceList hydrated with the correct path' do
        org = described_class.new(id: 'id')

        stub_get(
          path: "organizations/#{org.id}/organizers/?page=1",
          body: {
            organizers: [{ id: 'o' }]
          }
        )

        list = org.organizers.page(1)

        expect(list.first.id).to eq('o')
      end
    end

    describe '#owned_events' do
      it 'returns the response for #events' do
        org = described_class.new(id: 'id')

        allow(org).to receive(:events).and_return('yay')

        result = org.owned_events

        expect(result).to eq('yay')
      end
    end

    describe '#search_orders' do
      it 'returns correctly instantiated ResourceList' do
        stub_get(
          path: 'organizations/8675309/orders/?page=1',
          body: {
            orders: [{ id: '8675309' }]
          }
        )

        subject = described_class.new(id: '8675309')

        allow(EventbriteSDK::ResourceList).
          to receive(:new).and_call_original

        list = subject.search_orders

        expect(EventbriteSDK::ResourceList).
          to have_received(:new).
          with({
            url_base: 'organizations/8675309/orders',
            object_class: EventbriteSDK::Order,
            key: :orders,
            query: {}
          })

        result = list.page(1).map{ |order| order.id }

        expect(result).to eq(['8675309'])
      end

      it 'supports changed_since as a string' do
        stub_get(
          path: 'organizations/8675309/orders/?page=1&changed_since=2010-01-31T13:00:00Z',
          body: {
            orders: [{ id: '8675309' }]
          }
        )

        subject = described_class.new(id: '8675309')

        result = subject.search_orders(changed_since: '2010-01-31T13:00:00Z').page(1)

        result = result.map{ |order| order.id }

        expect(result).to eq(['8675309'])
      end

      it 'supports changed since as a datetime object' do
        now = Time.now()

        formatted = now.strftime('%FT%TZ')

        stub_get(
          path: "organizations/8675309/orders/?changed_since=#{formatted}&page=1",
          body: {
            orders: [{ id: '8675309' }]
          }
        )

        subject = described_class.new(id: '8675309')

        result = subject.search_orders(changed_since: now).page(1)

        result = result.map{ |order| order.id }

        expect(result).to eq(['8675309'])
      end

      it 'supports exclude_emails' do
        emails = ['joe@camel.org','a@b.com']
        encoded = emails.join(',')
        encoded = url_encode(encoded)

        stub_get(
          path: "organizations/8675309/orders/?exclude_emails=#{encoded}&page=1",
          body: {
            orders: [{ id: '8675309' }]
          }
        )

        subject = described_class.new(id: '8675309')

        result = subject.search_orders(exclude_emails: emails).page(1)

        result = result.map{ |order| order.id }

        expect(result).to eq(['8675309'])
      end

      it 'supports only_emails' do
        emails = ['joe@camel.org','a@b.com']
        encoded = emails.join(',')
        encoded = url_encode(encoded)

        stub_get(
          path: "organizations/8675309/orders/?only_emails=#{encoded}&page=1",
          body: {
            orders: [{ id: '8675309' }]
          }
        )

        subject = described_class.new(id: '8675309')

        result = subject.search_orders(only_emails: emails).page(1)

        result = result.map{ |order| order.id }

        expect(result).to eq(['8675309'])
      end

      it 'supports status' do
        stub_get(
          path: "organizations/8675309/orders/?status=LOUD_NOISES&page=1",
          body: {
            orders: [{ id: '8675309' }]
          }
        )

        subject = described_class.new(id: '8675309')

        result = subject.search_orders(status: 'LOUD_NOISES').page(1)

        result = result.map{ |order| order.id }

        expect(result).to eq(['8675309'])
      end
    end

    describe '#ticket_classes' do
      it 'returns a ResourceList hydrated with the correct path' do
        org = described_class.new(id: 'id')

        stub_get(
          path: "organizations/#{org.id}/ticket_classes/?page=1",
          body: {
            ticket_classes: [{ id: 't' }]
          }
        )

        list = org.ticket_classes.page(1)

        expect(list.first.id).to eq('t')
      end
    end

    describe '#ticket_groups' do
      it 'returns a ResourceList hydrated with the correct path' do
        org = described_class.new(id: 'id')

        stub_get(
          path: "organizations/#{org.id}/ticket_groups/?page=1",
          body: {
            ticket_groups: [{ id: 't' }]
          }
        )

        list = org.ticket_groups.page(1)

        expect(list.first.id).to eq('t')
      end
    end

    describe '#upcoming_events' do
      it 'returns a ResourceList hydrated with the correct path' do
        org = described_class.new(id: 'id')

        stub_get(
          path: "organizations/#{org.id}/events/?page=1&order_by=#{described_class::START_OLDEST_FIRST}&status=#{described_class::ALL}",
          body: {
            events: [{ id: 'e' }]
          }
        )

        list = org.upcoming_events.page(1)

        expect(list.first.id).to eq('e')
      end

      it 'accepts a custom order_by value' do
        subject = described_class.new(id: 'id')

        stub_get(
          path: "organizations/#{subject.id}/events/?page=1&order_by=my_order&status=#{described_class::ALL}",
          body: {
            events: [{ id: 'e' }]
          }
        )

        subject.upcoming_events(order_by: 'my_order').page(1)
      end

      it 'accepts a custom status value' do
        subject = described_class.new(id: 'id')

        stub_get(
          path: "organizations/#{subject.id}/events/?page=1&order_by=#{described_class::START_OLDEST_FIRST}&status=my_status",
          body: {
            events: [{ id: 'e' }]
          }
        )

        subject.upcoming_events(status: 'my_status').page(1)
      end
    end
  end
end
