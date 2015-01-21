require 'spec_helper'

describe SirenClient::Action do
  let (:action_data) { {"name":"search","method":"GET","href":"http://argo-retail-demo.herokuapp.com/products","fields":[{"name":"search","type":"text"}]} }

  describe '.new(data)' do
      it 'raise an error if wrong type is provided' do
        expect { SirenClient::Action.new([]) }.to raise_error(ArgumentError)
      end
      it 'can be instanciated with a hash' do
        expect(SirenClient::Action.new(action_data)).to be_a SirenClient::Action
      end
  end

  let (:action) { SirenClient::Action.new(action_data) }
  describe '.payload' do
    it 'is a hash' do
      expect(action.payload).to be_a Hash
    end
  end
  describe '.name' do
    it 'is a string' do
      expect(action.name).to be_a String
    end
  end
  describe '.classes' do
    it 'is an array' do
      expect(action.classes).to be_a Array
    end
  end
  describe '.method' do
    it 'is a string' do
      expect(action.method).to be_a String
    end
    it 'defaults to GET' do
      expect(SirenClient::Action.new({ }).method).to eq('GET')
    end
  end
  describe '.href' do
    it 'is a string' do
      expect(action.href).to be_a String
    end
  end
  describe '.title' do
    it 'is a string' do
      expect(action.title).to be_a String
    end
  end
  describe '.type' do
    it 'is a string' do
      expect(action.type).to be_a String
    end
  end
  describe '.fields' do
    it 'is an array' do
      expect(action.fields).to be_a Array
    end
    it 'is an array of SirenClient::Field\'s' do
      action.fields.each do |field|
        expect(field).to be_a SirenClient::Field
      end
    end
  end
end
