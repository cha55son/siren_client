require 'helper/live_spec_helper'

URL = 'http://localhost:9292'
describe HTTParty do
  it 'can access the server' do
    expect{ HTTParty.get(URL) }.to_not raise_error
  end
end

describe SirenClient do
  context 'when creating an entity' do
    it 'can set HTTP headers' do
      expect {
        a_client = SirenClient.get({
          url: URL, 
          headers: { "Accept" => "application/json" }
        })
        expect(a_client.config[:headers]).to be_a Hash
        expect(a_client.config[:headers]).to eq({ 
          "Accept" => "application/json"
        })
      }.to_not raise_error
    end
    it 'can set basic auth' do
      expect {
        a_client = SirenClient.get({
          url: URL,
          basic_auth: { username: 'billy', password: '1234' }
        })
        expect(a_client.config).to be_a Hash
        expect(a_client.config[:basic_auth]).to eq({ 
          username: "billy",
          password: "1234"
        })
      }.to_not raise_error
    end
  end

  let (:client) { SirenClient.get(URL) }
  context 'when accessing the root entity' do
    it 'to return an entity' do
      expect(client).to be_a SirenClient::Entity
    end
    it 'to access properties' do
      expect(client.properties['name']).to eq('Test 1')
    end
    it 'to not have entities' do
      expect(client.length).to eq(0)
    end
  end
  context 'when accessing a link' do
    it 'to return a link' do
      expect(client.links['concepts']).to be_a SirenClient::Link
    end
    it 'to follow the link' do
      expect(client.concepts).to be_a SirenClient::Entity
      expect(concepts.href).to eq(URL + '/concepts')
    end
  end
  context 'when accessing an action' do
    it 'to return an action' do
      expect(client.filter_concepts).to be_a SirenClient::Action
    end
    context 'with .where' do
      it 'to execute the action' do
        params = { search: 'obama' }
        expect(client.filter_concepts.where(params)).to be_a SirenClient::Entity
        expect(client.filter_concepts.where(params).length).to eq(1)
        expect(client.filter_concepts.where(params)[0]).to be_a SirenClient::Entity
        expect(client.filter_concepts.where(params)[0].category).to eq('PERSON')
      end
    end
  end

  let (:concepts) { SirenClient.get(URL).concepts }
  context 'when accessing an entity' do
    it 'to return an entity' do
      expect(concepts).to be_a SirenClient::Entity
    end
  end
end
