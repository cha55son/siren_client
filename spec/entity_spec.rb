require 'spec_helper'

describe SirenClient::Entity do
  let (:valid_url) { 'http://argo-retail-demo.herokuapp.com/products' }
  
  describe '.new(url)' do
    it 'raise an error is no url is provided' do
        expect { SirenClient::Entity.new }.to raise_error(ArgumentError)
    end
    it 'raise an error if an invalid url is provided' do
        expect { SirenClient::Entity.new('error me') }.to raise_error(SirenClient::InvalidURIError)
    end
    it 'raise an error if the url does not return json' do
        expect { SirenClient::Entity.new('http://www.google.com') }.to raise_error(SirenClient::InvalidResponseError)
    end
    it 'can be instanciated with a proper url' do 
        expect(SirenClient::Entity.new(valid_url)).to be_a SirenClient::Entity
    end
  end

  let (:entity) { SirenClient::Entity.new(valid_url) }
  describe '.attributes' do
    it 'access to the payload attribute' do
      expect(entity.payload).to be_a Hash
    end
    it 'access to the classes attribute' do
      expect(entity.classes).to be_a Array
    end
    it 'access to the rels attribute' do
      expect(entity.rels).to be_a Array
    end
    it 'access to the properties attribute' do
      expect(entity.properties).to be_a Hash
    end
  end
end
