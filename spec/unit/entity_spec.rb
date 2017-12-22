require 'helper/spec_helper'

describe SirenClient::Entity do
  subject { SirenClient::Entity }

  describe '.new(data)' do
    it 'raise an error if no param is provided' do
      expect { subject.new }.to raise_error(ArgumentError)
    end

    it 'raise an error if an invalid type is provided' do
      expect { subject.new([]) }.to raise_error(ArgumentError)
    end

    it 'raise an error if an invalid url is provided' do
      expect { subject.new('error me') }.to raise_error(SirenClient::InvalidURIError)
    end

    it 'raise an error if the url does not return json' do
      expect { subject.new('http://www.google.com') }.to raise_error(SirenClient::InvalidResponseError)
    end

    it 'can be instanciated with a hash of data' do
      expect(subject.new(siren_body)).to be_a SirenClient::Entity
    end
  end

  describe 'a SirenClient::Entity instance' do
    let (:entity) {
      subject.new(siren_body, {
        headers: { "Accept" => "application/json" }
      })
    }
    let (:graph) { entity[0] }

    context 'when initialized with stringified keys' do
      it_behaves_like 'a SirenClient::Entity'
    end

    context 'when initialized with symbolized keys' do
      let (:entity) {
        subject.new(siren_body.deep_symbolize_keys, {
          headers: { "Accept" => "application/json" }
        })
      }
      let (:graph) { entity[0] }

      it_behaves_like 'a SirenClient::Entity'
    end
  end

end
