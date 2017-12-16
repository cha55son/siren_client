shared_examples 'a SirenClient::Field' do
  describe '.payload' do
    it 'is a hash' do
      expect(field.payload).to be_a Hash
    end
  end

  context 'when payload contains data' do
    describe '.name' do
      it 'is a string' do
        expect(field.name).to eq field_data['name']
      end
    end

    describe '.type' do
      it 'is a string' do
        expect(field.type).to eq field_data['type']
      end
    end

    describe '.value' do
      it 'is a string' do
        expect(field.value).to eq field_data['value']
      end
    end

    describe '.title' do
      it 'is a string' do
        expect(field.title).to eq field_data['title']
      end
    end
  end
end
