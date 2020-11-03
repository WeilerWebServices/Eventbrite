require 'spec_helper'

module EventbriteSDK
  RSpec.describe Discount do
    it 'responds to defined schema' do
      expect(subject).to respond_to(:amount_off)
      expect(subject).to respond_to(:code)
      expect(subject).to respond_to(:discount_type)
      expect(subject).to respond_to(:end_date)
      expect(subject).to respond_to(:end_date_relative)
      expect(subject).to respond_to(:event_id)
      expect(subject).to respond_to(:hold_ids)
      expect(subject).to respond_to(:id)
      expect(subject).to respond_to(:percent_off)
      expect(subject).to respond_to(:quantity_available)
      expect(subject).to respond_to(:start_date)
      expect(subject).to respond_to(:start_date_relative)
      expect(subject).to respond_to(:ticket_group_id)
      expect(subject).to respond_to(:ticket_ids)
    end

    describe '#access_hidden_tickets?' do
      context 'when discount_type is ACCESS_HIDDEN_TICKETS' do
        it 'returns true' do
          subject.assign_attributes(
            discount_type: described_class::ACCESS_HIDDEN_TICKETS
          )
          expect(subject).to be_access_hidden_tickets
        end
      end

      context 'when discount_type is not ACCESS_HIDDEN_TICKETS' do
        it 'returns false' do
          subject.assign_attributes(discount_type: 'foo')
          expect(subject).not_to be_access_hidden_tickets
        end
      end
    end

    describe '#access_holds?' do
      context 'when discount_type is ACCESS_HOLDS' do
        it 'returns true' do
          subject.assign_attributes(
            discount_type: described_class::ACCESS_HOLDS
          )
          expect(subject).to be_access_holds
        end
      end

      context 'when discount_type is not ACCESS_HOLDS' do
        it 'returns false' do
          subject.assign_attributes(discount_type: 'foo')
          expect(subject).not_to be_access_holds
        end
      end
    end

    describe '#delete' do
      it 'makes a DELETE request with the given attributes to the correct URL and returns true' do
        subject = described_class.new(id: 'abc123')
        path = "discounts/#{subject.id}"

        stub_delete(path: path)

        result = subject.delete

        expect(result).to eq(true)
        expect(path).to have_received_request(:delete).with(body: nil)
      end
    end

    describe '#event' do
      it 'retrieves the event and returns it' do
        stub_get(
          path: 'events/abc',
          body: { id: 'abc' }
        )

        subject.assign_attributes(event_id: 'abc')

        expect(subject.event).to be_a(Event)
        expect('events/abc').to have_received_request(:get)
      end
    end

    describe '#protected_discount?' do
      context 'when discount_type is PROTECTED_DISCOUNT' do
        it 'returns true' do
          subject.assign_attributes(
            discount_type: described_class::PROTECTED_DISCOUNT
          )
          expect(subject).to be_protected_discount
        end
      end

      context 'when discount_type is not PROTECTED_DISCOUNT' do
        it 'returns false' do
          subject.assign_attributes(discount_type: 'foo')
          expect(subject).not_to be_protected_discount
        end
      end
    end

    describe '#public_discount?' do
      context 'when discount_type is PUBLIC_DISCOUNT' do
        it 'returns true' do
          subject.assign_attributes(
            discount_type: described_class::PUBLIC_DISCOUNT
          )
          expect(subject).to be_public_discount
        end
      end

      context 'when discount_type is not PUBLIC_DISCOUNT' do
        it 'returns false' do
          subject.assign_attributes(discount_type: 'foo')
          expect(subject).not_to be_public_discount
        end
      end
    end

    describe '#save' do
      it 'posts the given attributes to the correct URL and returns true' do
        attrs = {
          amount_off: 999,
          discount_type: described_class::PROTECTED_DISCOUNT
        }
        stub_post(
          path: 'discounts',
          body: { id: 'foo' }
        )

        subject.assign_attributes(attrs)
        result = subject.save

        expect(result).to eq(true)
        expect('discounts').to have_received_request(:post).with(
          body: { discount: attrs }
        )
      end

      context 'when event_id is given' do
        it 'also includes the event id in the request' do
          attrs = {
            amount_off: 999,
            discount_type: described_class::PROTECTED_DISCOUNT,
            event_id: 'event123'
          }
          stub_post(
            path: 'discounts',
            body: { id: 'foo' }
          )

          subject.assign_attributes(attrs)
          result = subject.save

          expect(result).to eq(true)
          expect('discounts').to have_received_request(:post).with(
            body: { discount: attrs }
          )
        end
      end
    end

    describe '#ticket_group' do
      it 'retrieves the ticket_group and returns it' do
        stub_get(
          path: 'ticket_groups/abc',
          body: { id: 'abc' }
        )

        subject.assign_attributes(ticket_group_id: 'abc')

        expect(subject.ticket_group).to be_a(TicketGroup)
        expect('ticket_groups/abc').to have_received_request(:get)
      end
    end

    describe '#ticket_group_accessible?' do
      context 'when ticket_group_id is present' do
        context 'and ticket_group is defined in the attributes' do
          context 'and the value is not nil' do
            it 'returns true' do
              subject = described_class.new(
                ticket_group: { id: 'abc123' },
                ticket_group_id: 'abc123'
              )

              expect(subject).to be_ticket_group_accessible
            end
          end

          context 'and the value is nil' do
            it 'returns false' do
              subject = described_class.new(
                ticket_group: nil,
                ticket_group_id: 'abc123'
              )

              expect(subject).not_to be_ticket_group_accessible
            end
          end
        end

        context 'and ticket_group is not defined in the attributes' do
          it 'returns false' do
            # Since ticket_group is not defined in the schema, but as a
            # relationship, it is not going to be present in the attrs unless
            # you give it.
            subject = described_class.new(ticket_group_id: 'abc123')

            expect(subject).not_to be_ticket_group_accessible
          end
        end
      end
    end
  end
end
