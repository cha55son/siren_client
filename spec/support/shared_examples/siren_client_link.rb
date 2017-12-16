shared_examples 'a SirenClient::Link' do
  describe '.go' do
    it 'follows the link\'s href' do
      # We just need to know that the link will make the request.
      expect { link.go }.to raise_error(SirenClient::InvalidResponseError)
    end
  end

  describe 'when initialized with data' do
    describe '.payload' do
      it 'is a hash' do
        expect(link.payload).to be_a Hash
      end
    end

    describe '.rels' do
      it 'is an array' do
        expect(link.rels).to match_array link_data['rel']
      end
    end

    describe '.href' do
      it 'is a string' do
        expect(link.href).to eq link_data['href']
      end

      it 'can change .href as needed' do
        link.href = link.href + '?query=test'
        expect(/query=test/).to match(link.href)
      end
    end

    describe '.title' do
      it 'is a string' do
        expect(link.title).to eq link_data['title']
      end
    end

    describe '.type' do
      it 'is a string' do
        expect(link.type).to eq link_data['type']
      end
    end
  end
end
