require 'spec_helper'

describe ShareNotify::Graph do
  describe '#new' do
    subject { build(:document_v2) }
    its(:id) { is_expected.not_to be_empty }
    its(:type) { is_expected.to eq('CreativeWork') }
    its(:push_doc) { is_expected.to be_an_instance_of(ShareNotify::PushDocument) }
  end

  describe '#to_share_v2' do
    subject { JSON.parse(example.to_share_v2.to_json) }
    let(:example) { build(:document_v2) }
    let(:fixture) { JSON.parse(File.read(File.join(fixture_path, 'share_v2.json'))) }
    it { is_expected.to eq(fixture) }
  end

  describe '#creative_work' do
    it "returns expected creative_work array" do
      sub = build(:document_v2)
      results = [{ :@id => sub.id,
                   :@type => "CreativeWork",
                   title: "V2 title",
                   language:  "English",
                   date_updated:  "1990-12-12T07:12:12Z",
                   extra: { funding: 'funding notes' },
                   is_deleted: false }]
      expect(sub.creative_work).to eq(results)
    end
  end

  describe '#is_deleted' do
    it "sets is_deleted flag when deleted" do
      sub = build(:document_v2)
      sub.push_doc.delete
      results = [{ :@id => sub.id,
                   :@type => "CreativeWork",
                   title: "V2 title",
                   language:  "English",
                   is_deleted: true,
                   date_updated:  "1990-12-12T07:12:12Z",
                   extra: { funding: 'funding notes' } }]
      expect(sub.creative_work).to eq(results)
    end
  end

  describe '#related_agents' do
    it "returns the expected related_agents array" do
      sub = build(:document_v2)
      results = [
        {
          :@id => "_:0e984e9bf84f3b7a35d3a120957cc82f",
          :@type => "person",
          :name => "person name"
        }, {
          :@id => "_:3b6f957643cc50ae52d280c7991ad465",
          :@type => "creator",
          agent: {
            :@id => "_:0e984e9bf84f3b7a35d3a120957cc82f",
            :@type => "person"
          },
          creative_work: {
            :@id => "_:07a28694bee83e0c13ef065289727fa9",
            :@type => "CreativeWork"
          }
        }
      ]
      expect(sub.related_agents).to eq(results)
    end
  end

  describe '#workidentifer' do
    it "returns the expected workidentifer hash" do
      sub = build(:document_v2)
      results = {
        :@id => "_:da8fe8fc47e18b435d6fe52ce7376f2d",
        :@type => "WorkIdentifier",
        uri: "http://example.com/",
        creative_work: {
          :@id => "_:07a28694bee83e0c13ef065289727fa9",
          :@type => "CreativeWork"
        }
      }
      expect(sub.workidentifer).to eq(results)
    end
  end

  describe '#tags' do
    it "returns the expected tags arrary" do
      sub = build(:document_v2)
      results = [
        {
          :@id => "_:e32f94dc18d0c5b62f364c177484172a",
          :@type => "Tag",
          name: "tag1"
        }, {
          :@id => "_:77b55fbf0ee62769ec7aa7587557b60a",
          :@type => "ThroughTags",
          tag: {
            :@id => "_:e32f94dc18d0c5b62f364c177484172a",
            :@type => "Tag"
          },
          creative_work: {
            :@id => "_:07a28694bee83e0c13ef065289727fa9",
            :@type => "CreativeWork"
          }
        }, {
          :@id => "_:15a70ba2e0026a8eee02a812f81e1c31",
          :@type => "Tag",
          name: "tag2"
        }, {
          :@id => "_:c6a2b0390f4a1edc79995598806f44f5",
          :@type => "ThroughTags",
          tag: {
            :@id => "_:15a70ba2e0026a8eee02a812f81e1c31",
            :@type => "Tag"
          },
          creative_work: {
            :@id => "_:07a28694bee83e0c13ef065289727fa9",
            :@type => "CreativeWork"
          }
        }
      ]
      expect(sub.tags).to eq(results)
    end
  end
end
