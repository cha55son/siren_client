require 'helper/spec_helper'

describe SirenClient::Action do
  let (:action_data) { {"name"=>"search","method"=>"GET","href"=>"http://example.com/products","fields"=>[{"name"=>"search","type"=>"text"}]} }
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
  end
