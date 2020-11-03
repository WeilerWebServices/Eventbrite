require 'spec_helper'

module EventbriteSDK
  RSpec.describe BlankResourceList do
    subject { described_class.new(key: 'key') }

    describe '#concat' do
      it 'returns what was given' do
        result = subject.concat([1])

        expect(result).to eq [1]
      end
    end

    describe '#next_page' do
      it 'returns itself' do
        expect(subject.next_page).to eq(subject)
      end
    end

    describe '#prev_page' do
      it 'returns itself' do
        expect(subject.prev_page).to eq(subject)
      end
    end

    describe '#retrieve' do
      it 'returns itself' do
        expect(subject.retrieve).to eq(subject)
      end
    end

    describe '#page' do
      it 'returns itself' do
        expect(subject.page(1)).to eq(subject)
      end
    end

    describe '#with_expansion' do
      it 'returns itself' do
        expect(subject.with_expansion(:literally_anything)).to eq(subject)
      end
    end

    describe '#to_json' do
      it 'returns a stringified JSON payload matching an actual ResourceList' do
        expect(subject.to_json).to eq('{"key":[]}')
      end
    end

    describe '#object_count' do
      it 'returns zero' do
        expect(subject.object_count).to be_zero
      end
    end
  end
end
