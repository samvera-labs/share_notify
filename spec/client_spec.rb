require 'spec_helper'

describe ShareNotify::Client::GraphNode do
  

  describe '#new' do
    context 'with type and attributes' do
      subject { described_class.new(
               "WorkIdentifier", uri: "http://example.com", 
                          creative_work:[described_class.new("article", title: "alice test")]

        )}

      its(:type) { is_expected.to eq("WorkIdentifier") }
    end
  end
end
