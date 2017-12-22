require 'helper/spec_helper'

describe SirenClient::Action do
  let (:action_data) { {"name"=>"search","method"=>"GET","href"=>"http://example.com/products", "class"=>["test"], "title"=>"test", "type"=>"text/html", "fields"=>[{"name"=>"search"}]} }
  let (:action_data_post) { {"name"=>"search","method"=>"POST","href"=>"http://example.com/products","fields"=>[{"name"=>"search","type"=>"text"}]} }
  let (:action_data_delete) { {"name"=>"delete","method"=>"DELETE","href"=>"http://example.com/products"} }

  subject { SirenClient::Action }

  describe '.new(data)' do
    it 'raise an error if wrong type is provided' do
      expect { subject.new([]) }.to raise_error(ArgumentError)
    end
    it 'can be instantiated with a hash' do
      expect(subject.new(action_data)).to be_a SirenClient::Action
    end
  end

  let (:output_buffer) {
    StringIO.new
  }

  describe 'a SirenClient::Action instance' do
    context 'when initialized with stringified keys' do
      let (:action) {
        subject.new(action_data, {
          headers: { "Accept" => "application/json" },
          debug_output: output_buffer
        })
      }
      let (:action_post) {
        subject.new(action_data_post, {
          debug_output: output_buffer
        })
      }
      let (:action_delete) {
        subject.new(action_data_delete, {
          debug_output: output_buffer
        })
      }

      it_behaves_like 'a SirenClient::Action'
    end

      context 'when initialized with symbolized keys' do
        let (:action) {
          subject.new(action_data.deep_symbolize_keys, {
            headers: { "Accept" => "application/json" },
            debug_output: output_buffer
          })
        }
        let (:action_post) {
          subject.new(action_data_post.deep_symbolize_keys, {
            debug_output: output_buffer
          })
        }
        let (:action_delete) {
          subject.new(action_data_delete.deep_symbolize_keys, {
            debug_output: output_buffer
          })
        }

        it_behaves_like 'a SirenClient::Action'
      end
  end

  describe 'when initialized with no data' do
    let (:action) {
      subject.new({ "fields" => [{}] }, {
        headers: {},
        debug_output: output_buffer
      })
    }

    describe '.payload' do
      it 'is a hash' do
        expect(action.payload).to be_a Hash
      end
      it 'is NOT overwritten with SirenClient::Field classes' do
        expect(action.payload['fields'][0]).to be_a Hash
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
        expect(subject.new({ }).method).to eq('get')
      end
    end

    describe '.href' do
      it 'is a string' do
        expect(action.href).to be_a String
      end
      it 'can change .href as needed' do
        action.href = action.href + '?query=test'
        expect(/query=test/).to match(action.href)
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
      it 'defaults to \'application/x-www-form-urlencoded\'' do
        expect(action.type).to eq('application/x-www-form-urlencoded')
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
end
