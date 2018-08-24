# frozen_string_literal: true

require 'spec_helper'
require 'support/vcr'

describe ShareNotify::API do
  before do
    allow(ShareNotify).to receive(:config) { { 'token' => 'SECRET_TOKEN' } }
    WebMock.enable!
  end

  after do
    WebMock.disable!
  end

  describe '#get' do
    subject { described_class.new.get }
    it 'is successful' do
      VCR.use_cassette('share_notify', record: :none) do
        expect(subject.code).to eq(200)
      end
    end
  end

  describe '#post' do
    subject { described_class.new.post(post_data) }
    context 'when creating a new document' do
      let(:post_data) { File.read(File.join(fixture_path, 'share.json')) }
      it 'is successful' do
        VCR.use_cassette('share_notify', record: :none) do
          expect(subject.code).to eq(201)
        end
      end
    end
    context 'when deleting an existing document' do
      let(:post_data) { File.read(File.join(fixture_path, 'share_delete.json')) }
      it 'is successful' do
        VCR.use_cassette('share_notify_delete', record: :none) do
          expect(subject.code).to eq(201)
        end
      end
    end
  end

  describe '#search' do
    context 'with a nil query' do
      subject { described_class.new.search(nil) }
      it 'returns no results' do
        VCR.use_cassette('share_notify', record: :none) do
          expect(subject.code).to eq(200)
          expect(subject['results']).to be_empty
        end
      end
    end
    context 'with a result query' do
      subject { described_class.new.search('asdf') }
      it 'returns no results' do
        VCR.use_cassette('share_notify', record: :none) do
          expect(subject.code).to eq(200)
          expect(subject['count']).to eq(2)
        end
      end
    end
  end
end
