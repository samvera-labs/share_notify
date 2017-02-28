require 'spec_helper'

describe ShareNotify::Graph do

  describe '#new' do
      subject { build(:document_v2) }
      its(:id) { is_expected.not_to be_empty }
      its(:type) { is_expected.to eq('CreativeWork') }
      its(:push_doc) { is_expected.to be_an_instance_of(ShareNotify::PushDocument)}
  end

  describe '#to_share_v2' do
     subject { JSON.parse(example.to_share_v2.to_json) }
     let(:example) { build(:document_v2) }
     let(:fixture) { JSON.parse(File.read(File.join(fixture_path, 'share_v2.json'))) }
   # it { is_expected.to eq(fixture) }
  end

  describe '#creative_work' do
   it "returns expected creative_work array" do
     sub = build(:document_v2)
    
    results = [{:@id => sub.id, 
                :@type => "CreativeWork", 
                "title" => "V2 title", 
                "language" => "English", 
                "date_updated" => "1990-12-12T07:12:12Z"}]
    expect(sub.creative_work).to eq(results)
    end
  end

  describe '#related_agents' do
    it "returns the expected related_agents array" do
     sub = build(:document_v2)
     results = [{
          "type": "person",
          "name": "person name",
          "id": "_:xxxxx"
        }, {
          "@id": "_:xxxxx",
          "@type": "creator",
          "agent": {
            "@id": "_:xxxxx",
            "@type": "person"
          },
          "creative_work": {
            "@id": "_:xxxxx",
            "@type": "CreativeWork"
          }
        }]
     #expect(sub.related_agents).to eq(results)
    end
  end

  describe '#workidentifer' do
    it "returns the expected workidentifer hash" do
     sub = build(:document_v2)
     results = {
          "@id": "_:xxxxx",
          "@type": "WorkIdentifier",
          "uri": "http://example.com/",
          "creative_work": {
            "@id": "_:xxxxx",
            "@type": "CreativeWork"
           }
          }
     #expect(sub.workidentifer).to eq(results)
    end
  end

  describe '#tags' do
    it "returns the expected tags arrary" do
     sub = build(:document_v2)
     results = [{
          "@id": "_:xxxxx",
          "@type": "Tag",
          "title": "tag1"
        }, {
          "@id": "_:xxxxx",
          "@type": "ThroughTags",
          "tag": {
            "@id": "_:xxxxx",
            "@type": "Tag"
          },
          "creative_work": {
            "@id": "_:xxxxx",
            "@type": "CreativeWork"
          }
        },{
          "@id": "_:xxxxx",
          "@type": "Tag",
          "title": "tag2"
        }, {
          "@id": "_:xxxxx",
          "@type": "ThroughTags",
          "tag": {
            "@id": "_:xxxxx",
            "@type": "Tag"
          },
          "creative_work": {
            "@id": "_:xxxxx",
            "@type": "CreativeWork"
          }
        }]
     #expect(sub.tags).to eq(results)
    end
  end
end
