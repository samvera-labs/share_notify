require 'spec_helper'

describe ShareNotify::PushDocument do
  let(:uri) { 'http://foo' }

  describe '#new' do
    context 'without @param datetime' do
      subject { described_class.new(uri) }
      its(:contributors) { is_expected.to be_empty }
      its(:updated) { is_expected.not_to be_nil }
      its(:providerUpdatedDateTime) { is_expected.to eq(Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ')) }
      it { is_expected.not_to be_valid }
    end

    context 'with @param datetime which is time object' do
      let(:d_date) { DateTime.new(1990, 12, 12, 12, 12, 12, '+5') }
      subject { described_class.new(uri, d_date) }
      its(:providerUpdatedDateTime) { is_expected.to eq('1990-12-12T07:12:12Z') }
    end

    context 'with @param datetime which is not time object' do
      let(:d_date) { Date.today }
      subject { described_class.new(uri, d_date) }
      its(:providerUpdatedDateTime) { is_expected.to eq(Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ')) }
    end
  end

  describe '@providerUpdatedDateTime' do
    subject do
      valid = described_class.new(uri)
      valid.add_contributor(name: 'Job', email: 'joe@joe.com')
      valid.title = 'Some title'
      valid
    end
    it { is_expected.to be_valid }
  end

  describe 'a valid document' do
    subject do
      valid = described_class.new(uri)
      valid.add_contributor(name: 'Job', email: 'joe@joe.com')
      valid.title = 'Some title'
      valid
    end
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
      let(:date) { DateTime.new(1990, 12, 12, 12, 12, 12, '+5') }
      subject do
        valid = described_class.new(uri)
        valid.updated = date
        valid
      end
      its(:updated) { is_expected.to eq('1990-12-12T07:12:12Z') }
    end
  end

  describe '#version=' do
    subject do
      valid = described_class.new(uri)
      valid.version = 'someID'
      valid
    end
    its(:version) { is_expected.to eq(versionId: 'someID') }
  end

  describe '#description' do
    subject do
      obj = described_class.new(uri)
      obj.description = 'some description'
      obj
    end
    its(:description) { is_expected.to eq('some description') }
  end

  describe '#publisher' do
    context 'with a name' do
      subject do
        obj = described_class.new(uri)
        obj.publisher = { name: 'myname', uri: 'http://example.com' }
        obj
      end
      its(:publisher) { is_expected.to eq(name: 'myname', uri: 'http://example.com') }
    end

    context 'without a name' do
      subject do
        obj = described_class.new(uri)
        obj.publisher = { uri: 'http://example.com' }
        obj
      end
      its(:publisher) { is_expected.to be_nil }
    end
  end

  describe '#languages' do
    context '@param is an array' do
      subject do
        obj = described_class.new(uri)
        obj.languages = ['English']
        obj
      end
      its(:languages) { is_expected.to eq(['English']) }
    end

    context '@param is not an array' do
      subject do
        obj = described_class.new(uri)
        obj.languages = 'English'
        obj
      end
      its(:languages) { is_expected.to be_nil }
    end
  end

  describe '#tags' do
    context '@param is an array' do
      subject do
        obj = described_class.new(uri)
        obj.tags = ['tag1', 'tag2']
        obj
      end
      its(:tags) { is_expected.to eq(['tag1', 'tag2']) }
    end

    context '@param is not an array' do
      subject do
        obj = described_class.new(uri)
        obj.languages = 'tag1'
        obj
      end
      its(:tags) { is_expected.to be_nil }
    end
  end

  describe '#to_share' do
    let(:example) do
      doc = described_class.new('http://example.com/document1')
      doc.version = 'someID'
      doc.title = 'Interesting research'
      doc.updated = DateTime.new(2014, 12, 12)
      doc.add_contributor(name: 'Roger Movies Ebert', email: 'rogerebert@example.com')
      doc.add_contributor(name: 'Roger Madness Ebert')
      doc
    end
    let(:fixture) { JSON.parse(File.read(File.join(fixture_path, 'share.json'))) }
    subject { JSON.parse(example.to_share.to_json) }
    it { is_expected.to eq(fixture) }
  end
end
