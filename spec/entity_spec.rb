require 'spec_helper'

describe SirenClient::Entity do
  let (:valid_url) { 'http://argo-retail-demo.herokuapp.com/products' }
  let (:entity_hash) { {"class":["product"],"rel":["item"],"properties":{"id":"03283376000P","name":"Kenmore Replacement True HEPA Filter, Large Chassis","image":"http://c.shld.net/rpx/i/s/i/spin/image/spin_prod_170837701"},"links":[{"rel":["self"],"href":"http://argo-retail-demo.herokuapp.com/products/03283376000P"}]} }
  
  describe '.new(data)' do
    it 'raise an error if no param is provided' do
        expect { SirenClient::Entity.new }.to raise_error(ArgumentError)
    end
    it 'raise an error if an invalid type is provided' do
        expect { SirenClient::Entity.new([]) }.to raise_error(ArgumentError)
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
    it 'can be instanciated with a hash of data' do 
        expect(SirenClient::Entity.new(entity_hash)).to be_a SirenClient::Entity
    end
  end

  # Loop twice using the url and the entity hash
  2.times do |i|
    let (:entity) { SirenClient::Entity.new(valid_url) } if i == 1
    let (:entity) { SirenClient::Entity.new(entity_hash) } if i == 2
    describe '.payload' do
      it 'is a hash' do
        expect(entity.payload).to be_a Hash
      end
    end
    describe '.classes' do
      it 'is an array' do
        expect(entity.classes).to be_a Array
      end
    end
    describe '.properties' do
      it 'is a hash' do
        expect(entity.properties).to be_a Hash
      end
    end
    describe '.entities' do
      it 'is an array' do
        expect(entity.entities).to be_a Array
      end
      it 'is an array of SirenClient::Entity\'s' do
        entity.entities.each do |ent|
          expect(ent).to be_a SirenClient::Entity
        end
      end
    end
    describe '.rels' do
      it 'is an array' do
        expect(entity.rels).to be_a Array
      end
    end
    describe '.links' do
      it 'is an array' do
        expect(entity.links).to be_a Array
      end
      it 'is an array of SirenClient::Link\'s' do
        entity.links.each do |link|
          expect(link).to be_a SirenClient::Link
        end
      end
    end
    describe '.actions' do
      it 'is an array' do
        expect(entity.actions).to be_a Array
      end
      it 'is an array of SirenClient::Action\'s' do
        entity.actions.each do |action|
          expect(action).to be_a SirenClient::Action
        end
      end
    end
    describe '.title' do
      it 'is a string' do
        expect(entity.title).to be_a String
      end
    end
    describe '.href' do
      it 'is a string' do
        expect(entity.href).to be_a String
      end
    end
    describe '.type' do
      it 'is a string' do
        expect(entity.type).to be_a String
      end
    end
  end
end
