require 'helper/spec_helper'

describe SirenClient::Entity do
  
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
    # it 'can be instanciated with a proper url' do 
    #   expect(SirenClient::Entity.new(valid_url)).to be_a SirenClient::Entity
    # end
    it 'can be instanciated with a hash of data' do 
      expect(SirenClient::Entity.new(siren_body)).to be_a SirenClient::Entity
    end
  end

  let (:entity) { 
    SirenClient::Entity.new(siren_body, { 
      headers: { "Accept" => "application/json" } 
    })
  }
  describe '.config' do
    it 'is a hash' do
      expect(entity.config).to be_a Hash
    end
    it 'can access property in the config' do
      expect(entity.config[:headers]['Accept']).to eq('application/json')
    end
  end
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
    it 'can access a property' do
      expect(entity.properties['page']).to eq(1)
    end
    it 'can access a property directly on the entity' do
      expect(entity.page).to eq(1)
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
    it 'is a hash' do
      expect(entity.links).to be_a Hash
    end
    it 'is a hash of { key => SirenClient::Link }\'s' do
      expect {
        entity.links.each do |key, link|
          expect(key).to be_a String
          expect(link).to be_a SirenClient::Link
        end
      }.to_not raise_error
    end
    it 'can access a link' do
      expect(entity.links['self']).to be_a SirenClient::Link
    end
  end
  describe '.actions' do
    it 'is a hash' do
      expect(entity.actions).to be_a Hash
    end
    it 'is a hash of { key => SirenClient::Action }\'s' do
      expect {
        entity.actions.each do |name, action|
          expect(name).to be_a String
          expect(action).to be_a SirenClient::Action
        end
      }.to_not raise_error
    end
    it 'can access an action' do
      expect(entity.actions['filter_concepts']).to be_a SirenClient::Action
    end
  end
  # This will be empty unless it's an entity sub-link.
  describe '.href' do
    it 'is a string' do
      expect(entity.href).to be_a String
    end
    it 'should be empty' do
      expect(entity.href).to eq('')
    end
    it 'can change .href as needed' do
        entity.href = 'http://example.com?query=test'
        expect(/query=test/).to match(entity.href)
    end
  end
  # Similar to SirenClient::Link.go this function will create a 
  # new entity from the .href method. For entity sub-links only.
  describe '.go' do
    let (:graph) { entity[0] } 
    it 'return nil if it\'s NOT an entity sub-link' do
      expect(entity.go).to eq(nil)
    end
    it 'initiate a request if it IS an entity sub-link' do
      expect { graph.entities[0].go }.to raise_error
    end
  end
  describe '.invalidkey' do
    it 'will throw a NoMethodError' do
      expect { entity.thisdoesntexist }.to raise_error(NoMethodError)
    end
  end
  describe '.validkey' do
    let (:graph) { entity[0] } 
    it 'can access an entity sub-link within the entity' do
      expect { graph.messages }.to raise_error
    end
    it 'can access a link directly on the entity' do
      expect { entity.next }.to raise_error
    end
    it 'can access an action directly on the entity' do
      expect(entity.filter_concepts).to be_a SirenClient::Action
    end
  end
  describe '.title' do
    it 'is a string' do
      expect(entity.title).to be_a String
    end
  end
  describe '.type' do
    it 'is a string' do
      expect(entity.type).to be_a String
    end
  end
  describe '.length' do
    it 'can return the size of @entities' do
      expect(entity.length).to eq(1)
    end
  end
  describe '[x]' do
    it 'can get the first element' do
      expect(entity[0]).to be_a SirenClient::Entity
    end
    it 'can get the last element' do
      expect(entity[-1]).to be_a SirenClient::Entity
    end
    it 'causes entity sub-links to be traversed' do
      expect(entity[0]).to be_a SirenClient::Entity
    end
  end
  let (:graph) { entity[0] } 
  describe '.search("messages")' do
    it 'returns an Array' do
      expect(graph.search('messages')).to be_a Array
    end
    it 'returns an Array of the right size' do
      expect(graph.search('messages').length).to eq(1)
    end
    it 'the first element is a SirenClient::Entity' do
      expect(graph.search('messages')[0]).to be_a SirenClient::Entity
    end
    it 'the first element\'s classes include "messages"' do
      expect(graph.search('messages')[0].classes.include?('messages')).to eq(true)
    end
  end
  describe '.string(/test1/)' do
    it 'returns an Array' do
      expect(graph.search(/test1/)).to be_a Array
    end
    it 'returns an Array of the right size' do
      expect(graph.search(/test1/).length).to eq(1)
    end
    it 'the second element is a SirenClient::Entity' do
      expect(graph.search(/test1/)[0]).to be_a SirenClient::Entity
    end
    it 'the second element\'s classes include "concepts"' do
      expect(graph.search(/test1/)[0].classes.include?('messages')).to eq(true)
    end
  end
  describe '.string(/test[0-9]/)' do
    it 'returns an Array' do
      expect(graph.search(/test[0-9]/)).to be_a Array
    end
    it 'returns an Array of the right size' do
      expect(graph.search(/test[0-9]/).length).to eq(2)
    end
    it 'the second element is a SirenClient::Entity' do
      expect(graph.search(/test[0-9]/)[1]).to be_a SirenClient::Entity
    end
    it 'the second element\'s classes include "concepts"' do
      expect(graph.search(/test[0-9]/)[1].classes.include?('concepts')).to eq(true)
    end
  end
  describe 'underscore support' do
    it 'can access entity sub-links' do
      # Since this will trigger the sub-link. We expect an InvalidURIError
      expect { graph.user_preferences }.to raise_error(SirenClient::InvalidURIError)
    end
    it 'can access actions' do
      expect(entity.filter_messages).to be_a SirenClient::Action
    end
    it 'can access links' do
      # Since this will trigger the link. We expect an InvalidURIError
      expect { entity.prev_page }.to raise_error(SirenClient::InvalidURIError)
    end
  end
  # Entities enumerable support
  describe "enumerable support" do
    describe '.each' do
      it 'can iterate over all the entities' do
        expect {
          graph.each do |ent|
            expect(ent).to be_a SirenClient::Entity
          end
        }.to_not raise_error
      end
    end
    # Useful enumerable methods
    describe '.all?' do 
      it 'matches .entities.all?' do
        expect(
          graph.all? do |ent|
            ent == SirenClient::Entity
          end
        ).to eq(
          graph.entities.all? do |ent|
              ent == SirenClient::Entity
          end
        )
      end
    end
    describe '.find' do
      it 'matches .entities.find' do
        expect(
          graph.find do |ent|
            ent.rels.include?('/rels/messages')
          end
        ).to eq(
          graph.entities.find do |ent|
            ent.rels.include?('/rels/messages')
          end
        )
      end
    end
    describe '.find_all' do
      it 'matches .entities.find_all' do
        expect(
          graph.find_all do |ent|
            ent.classes.include?('collection')
          end
        ).to eq(
          graph.entities.find_all do |ent|
            ent.classes.include?('collection')
          end
        )
      end
    end
    describe '.first' do
      it 'matches .entities.first' do
        expect(graph.first).to eq(graph.entities.first)
      end
    end
    describe '.grep' do
      it "matches .entities.grep" do
        expect(
          graph.grep(/test1/) do |ent|
            ent.href
          end
        ).to eq(
          graph.entities.grep(/test1/) do |ent|
            ent.href
          end
        )
      end
    end
    describe '.map' do
      it 'matches .entities.map' do
        expect(
          graph.map do |ent|
            ent.classes.include?('concepts')
          end
        ).to eq(
          graph.entities.map do |ent|
            ent.classes.include?('concepts')
          end
        )
      end
    end
    describe '.reject' do
      it 'matches .entities.reject' do
        expect(
          graph.reject do |ent|
            ent.classes.include?('messages')
          end
        ).to eq(
          graph.entities.reject do |ent|
            ent.classes.include?('messages')
          end
        )
      end
    end
    describe '.select' do
      it 'matches .entities.select' do
        expect(
          graph.select do |ent|
            ent.rels.include?('/rels/concepts')
          end
        ).to eq(
          graph.entities.select do |ent|
            ent.rels.include?('/rels/concepts')
          end
        )
      end
    end
    describe '.sort' do
      it 'matches .entities.sort' do
        expect(
          graph.sort do |ent_a, ent_b|
            ent_b.classes[0] <=> ent_a.classes[0]
          end
        ).to eq(
          graph.entities.sort do |ent_a, ent_b|
            ent_b.classes[0] <=> ent_a.classes[0]
          end
        )
      end
    end
  end
end
