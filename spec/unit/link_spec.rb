require 'helper/spec_helper'

describe SirenClient::Link do
  let (:link_data) { {"rel"=>["self"],"href"=>"http://example.com/products/03283378000P"} }

  describe '.new(data)' do
      it 'raise an error if wrong type is provided' do
        expect { SirenClient::Link.new([]) }.to raise_error(ArgumentError)
      end
      it 'can be instanciated with a hash' do
        expect(SirenClient::Link.new(link_data)).to be_a SirenClient::Link
      end
  end

  let (:link) { SirenClient::Link.new(link_data) }
  describe '.go' do
    it 'follows the link\'s href' do
      # We just need to know that the link will make the request.
      expect { link.go }.to raise_error(SirenClient::InvalidResponseError)
    end
  end
  describe '.payload' do
    it 'is a hash' do
      expect(link.payload).to be_a Hash
    end
  end
  describe '.rels' do
    it 'is an array' do
      expect(link.rels).to be_a Array
    end
  end
  describe '.href' do
    it 'is a string' do
      expect(link.href).to be_a String
    end
    it 'can change .href as needed' do
        link.href = link.href + '?query=test'
        expect(/query=test/).to match(link.href)
    end
  end
  describe '.title' do
    it 'is a string' do
      expect(link.title).to be_a String
    end
  end
  describe '.type' do
    it 'is a string' do
      expect(link.type).to be_a String
    end
  end
end
