require 'spec_helper'
require 'support/vcr'

describe ShareNotify::Metadata do
  before(:all) do
    class MockObject
      include ShareNotify::Metadata
      attr_reader :url
    end
  end

  after(:all) { Object.send(:remove_const, :MockObject) if defined?(MockObject) }

  let(:object) { MockObject.new }

  it 'will delegate #share_notified? to the underlying NotificationQueryService' do
    expect(object.send(:notification_query_service)).to receive(:share_notified?)
    object.share_notified?
  end
end
