require 'helper/spec_helper'

describe SirenClient::Field do
  let (:field_data) { {"name"=>"search","type"=>"text", "value" => "test", "title" => "test"} }

  subject { SirenClient::Field }

  describe '.new(data)' do
    it 'raise an error if wrong type is provided' do
      expect { subject.new([]) }.to raise_error(ArgumentError)
    end

    it 'can be instanciated with a hash' do
      expect(subject.new(field_data)).to be_a SirenClient::Field
    end
  end

  describe 'a SirenClient::Field instance' do
    context 'when initialized with stringified keys' do
      let (:field) { subject.new(field_data) }

      it_behaves_like 'a SirenClient::Field'
    end

    context 'when initialized with symbolized keys' do
      let (:field) { subject.new(field_data.deep_symbolize_keys) }

      it_behaves_like 'a SirenClient::Field'
    end
  end

  context 'when payload contains no data' do
    let(:field) { subject.new({}) }

    describe '.name' do
      it 'is a string' do
        expect(field.name).to be_a String
      end
    end

    describe '.type' do
      it 'is a string' do
        expect(field.type).to be_a String
      end

      it 'default to "text"' do
        expect(subject.new({ }).type).to eq('text')
      end
    end

    describe '.value' do
      it 'is a string' do
        expect(field.value).to be_a String
      end
    end

    describe '.title' do
      it 'is a string' do
        expect(field.title).to be_a String
      end
    end
  end

end
