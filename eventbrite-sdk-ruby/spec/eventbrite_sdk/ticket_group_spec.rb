require 'spec_helper'

module EventbriteSDK
  RSpec.describe TicketGroup do
    # live, archived, deleted, or all
    it 'responds to defined schema' do
      expect(subject).to respond_to(:event_ticket_ids)
      expect(subject).to respond_to(:id)
      expect(subject).to respond_to(:name)
      expect(subject).to respond_to(:status)
    end

    describe '#archived?' do
      context 'when status is "archived"' do
        it 'returns true' do
          subject.assign_attributes(status: described_class::ARCHIVED)

          expect(subject).to be_archived
        end
      end

      context 'when status is not "archived"' do
        it 'returns false' do
          subject.assign_attributes(status: 'foo')

          expect(subject).not_to be_archived
        end
      end
    end

    describe '#delete' do
      it 'performs a delete request to /ticket_groups/:ticket_group_id/' do
        subject = described_class.new(id: 'group1')
        api_path =  'ticket_groups/group1'

        stub_delete(path: api_path)

        expect(subject.delete).to eq(true)
        expect(api_path).to have_received_request(:delete)
      end
    end

    describe '#deleted?' do
      context 'when status is "deleted"' do
        it 'returns true' do
          subject.assign_attributes(status: described_class::DELETED)

          expect(subject).to be_deleted
        end
      end

      context 'when status is not "deleted"' do
        it 'returns false' do
          subject.assign_attributes(status: 'foo')

          expect(subject).not_to be_deleted
        end
      end
    end

    describe '#live?' do
      context 'when status is "live"' do
        it 'returns true' do
          subject.assign_attributes(status: described_class::LIVE)

          expect(subject).to be_live
        end
      end

      context 'when status is not "live"' do
        it 'returns false' do
          subject.assign_attributes(status: 'foo')

          expect(subject).not_to be_live
        end
      end
    end

    describe '.retrieve' do
      it 'performs a get request to /ticket_groups/:ticket_group_id/' do
        stub_get(
          path: 'ticket_groups/group1',
          body: {
            event_ticket_ids: { 'ev1': ['tix100'] },
            id: 'foo',
            name: 'fooo',
            status: 'status'
          }
        )

        group = described_class.retrieve(id: 'group1')

        expect(group.event_ticket_ids.to_h).to eq('ev1' => ['tix100'])
        expect(group.id).to eq('foo')
        expect(group.name).to eq('fooo')
        expect(group.status).to eq('status')
      end
    end

    describe '#save' do
      it 'posts the payload to /ticket_groups/ and returns true' do
        attrs = {
          event_ticket_ids: { 'event1' => ['ticket_class1']},
          name: 'test@test.com',
          status: described_class::LIVE
        }
        api_path = 'ticket_groups'
        stub_post(path: api_path, body: { id: 'foo' })

        subject.assign_attributes(attrs)
        result = subject.save

        expect(result).to eq(true)

        expect(api_path).
          to have_received_request(:post).
          with(body: { ticket_group: attrs })
      end

      context 'when id is present' do
        it 'posts the payload to /ticket_groups/:ticket_group_id/' do
          attrs = {
            event_ticket_ids: { 'event1' => ['ticket_class1']},
            name: 'test@test.com',
            status: described_class::LIVE
          }
          api_path = 'ticket_groups/group1'
          stub_post(path: api_path, body: { id: 'foo' })

          subject = described_class.new(id: 'group1')
          subject.assign_attributes(attrs)
          result = subject.save

          expect(result).to eq(true)
          expect(api_path).
            to have_received_request(:post).
            with(body: { ticket_group: attrs })
        end
      end
    end
  end
end
