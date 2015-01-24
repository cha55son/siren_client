require 'helper/live_spec_helper'

URL = 'http://localhost:9292'
describe HTTParty do
  it 'can access the server' do
    expect{ HTTParty.get(URL) }.to_not raise_error
  end
end

describe SirenClient do
  let (:client) { SirenClient.get(URL) }

  context 'when accessing the root entity' do
    it 'can return an entity' do
      expect(client).to be_a SirenClient::Entity
    end
    it 'can access properties' do
      expect(client.properties['name']).to eq('Test 1')
    end
    it 'should not have entities or actions' do
      expect(client.length).to eq(0)
      expect(client.actions.length).to eq(0)
    end
  end
  context 'when accessing a link' do
    it 'can return a link' do
      expect(client.links['concepts']).to eq(SirenClient::Link)
    end
    it 'can follow the link' do
      expect(client.concepts).to be_a SirenClient::Entity
      expect(concepts.href).to eq(URL + '/concepts')
    end
  end

  let (:concepts) { SirenClient.get(URL).concepts }
  context 'when accessing an entity' do
    it 'can return an entity' do

    end
  end
  context 'when accessing an action' do

  end
end
