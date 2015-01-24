require 'helper/spec_helper'

describe SirenClient::Field do
  let (:field_data) { {"name"=>"search","type"=>"text"} }

  describe '.new(data)' do
      it 'raise an error if wrong type is provided' do
        expect { SirenClient::Field.new([]) }.to raise_error(ArgumentError)
      end
      it 'can be instanciated with a hash' do
        expect(SirenClient::Field.new(field_data)).to be_a SirenClient::Field
      end
  end

  let (:field) { SirenClient::Field.new(field_data) }
  describe '.payload' do
    it 'is a hash' do
      expect(field.payload).to be_a Hash
    end
  end
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
      expect(SirenClient::Field.new({ }).type).to eq('text')
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
