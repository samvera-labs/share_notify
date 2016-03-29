require 'spec_helper'

describe ShareNotify::PushDocument do
  let(:uri) { 'http://foo' }

  describe '#new' do
    context 'without @param datetime' do
      subject { build(:document) }
      its(:contributors) { is_expected.to be_empty }
      its(:updated) { is_expected.not_to be_nil }
      its(:providerUpdatedDateTime) { is_expected.to eq(Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ')) }
      it { is_expected.not_to be_valid }
    end

    context 'with @param datetime which is time object' do
      subject { build(:document_with_datetime) }
      its(:providerUpdatedDateTime) { is_expected.to eq('1990-12-12T07:12:12Z') }
    end

    context 'with @param datetime which is not time object' do
      subject { build(:document_with_date) }
      its(:providerUpdatedDateTime) { is_expected.to eq(Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ')) }
    end
  end

  describe 'a valid document' do
    subject { build(:valid_document) }
    it { is_expected.to be_valid }
  end

  describe '#add_contributor' do
    context 'without a name' do
      subject { described_class.new(uri).add_contributor(email: 'Bob') }
      it { is_expected.to be false }
    end
  end

  describe '#updated=' do
    context 'with a DateTime' do
      subject { build(:document, updated: DateTime.new(1990, 12, 12, 12, 12, 12, '+5')) }
      its(:updated) { is_expected.to eq('1990-12-12T07:12:12Z') }
    end
  end

  describe '#version=' do
    subject { build(:document, version: 'someID') }
    its(:version) { is_expected.to eq(versionId: 'someID') }
  end

  describe '#description' do
    subject { build(:document, description: 'some description') }
    its(:description) { is_expected.to eq('some description') }
  end

  describe '#publisher' do
    context 'with a name' do
      subject { build(:document, publisher: { name: 'myname', uri: 'http://example.com' }) }
      its(:publisher) { is_expected.to eq(name: 'myname', uri: 'http://example.com') }
    end

    context 'without a name' do
      subject { build(:document, publisher: { uri: 'http://example.com' }) }
      its(:publisher) { is_expected.to be_nil }
    end
  end

  describe '#languages' do
    context '@param is an array' do
      subject { build(:document, languages: ['English']) }
      its(:languages) { is_expected.to eq(['English']) }
    end

    context '@param is not an array' do
      subject { build(:document, languages: 'English') }
      its(:languages) { is_expected.to be_nil }
    end
  end

  describe '#tags' do
    context '@param is an array' do
      subject { build(:document, tags: ['tag1', 'tag2']) }
      its(:tags) { is_expected.to eq(['tag1', 'tag2']) }
    end

    context '@param is not an array' do
      subject { build(:document, tags: 'tag1') }
      its(:tags) { is_expected.to be_nil }
    end
  end

  context 'with complete documents' do
    subject { JSON.parse(example.to_share.to_json) }
    describe '#to_share' do
      let(:example) { build(:share_document) }
      let(:fixture) { JSON.parse(File.read(File.join(fixture_path, 'share.json'))) }
      it { is_expected.to eq(fixture) }
    end
    describe '#delete' do
      let(:example) { build(:delete_document) }
      let(:fixture) { JSON.parse(File.read(File.join(fixture_path, 'share_delete.json'))) }
      it { is_expected.to eq(fixture) }
    end
  end
end
