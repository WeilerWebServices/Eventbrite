require 'spec_helper'

module EventbriteSDK
  RSpec.describe User do
    describe '.me' do
      it 'returns a new instance with #id as "me"' do
        user = described_class.me

        expect(user.id).to eq('me')
      end
    end

    describe '#owned_event_orders' do
      it 'requests the users orders and returns them' do
        subject = described_class.new(id: '123')

        stub_get(
          path: 'users/123/owned_event_orders/?page=1',
          body: {
            orders: [{ id: 'e' }]
          }
        )

        list = subject.owned_event_orders.page(1)
        result = list.map { |order| order.id }

        expect(result).to eq(['e'])
      end
    end
  end
end
