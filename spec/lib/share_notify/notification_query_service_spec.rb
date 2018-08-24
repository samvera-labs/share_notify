# frozen_string_literal: true

require 'spec_helper'
require 'share_notify/notification_query_service'
require 'support/vcr'

RSpec.describe ShareNotify::NotificationQueryService do
  it 'fails to initialize if the given context does not respond to #url' do
    object = double
    expect { described_class.new(object) }.to raise_error(ShareNotify::InitializationError)
  end

  context '#share_notified?' do
    before { WebMock.enable! }
    after { WebMock.disable! }
    it 'is true when object is already in SHARE' do
      object = double('Share-able OBJECT', url: 'http://example.com/document1')
      subject = described_class.new(object)
      VCR.use_cassette('share_metadata', record: :none) do
        expect(subject).to be_share_notified
      end
    end
    it 'is false when object is not in SHARE' do
      object = double('Share-able OBJECT', url: 'http://example.com/bogusDoc')
      subject = described_class.new(object)
      VCR.use_cassette('share_metadata', record: :none) do
        expect(subject).not_to be_share_notified
      end
    end
  end
end
