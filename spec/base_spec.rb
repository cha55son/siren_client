require 'spec_helper'

describe SirenClient do
  let (:valid_url)         { 'http://argo-retail-demo.herokuapp.com/products' }
  let (:invalid_url)       { 'http://www.google.com' }
  let (:url_error_msg)     { 'You must supply a valid url to SirenClient.get' }
  let (:invalid_param_msg) { 'You must supply either a string or hash to SirenClient.get' }

  describe '.get(config)' do
    it "raise an error if no options are provided" do
        expect { SirenClient.get }.to raise_error(ArgumentError)
    end
    it "raise an error if an improper param is provided" do
        expect { SirenClient.get([1, 2, 3]) }.to raise_error(ArgumentError, invalid_param_msg) 
        expect { SirenClient.get(nil) }.to raise_error(ArgumentError, invalid_param_msg)
    end
    it "raise an error if no url is provided" do
        expect { SirenClient.get(url: nil) }.to raise_error(ArgumentError, url_error_msg)
    end
    it "raise an error if an invalid url is provided" do
        expect { SirenClient.get('error on me') }.to raise_error(SirenClient::InvalidURIError)
    end
    it "raise an error if the url does not return json" do
        expect { SirenClient.get(invalid_url) }.to raise_error(SirenClient::InvalidResponseError)
    end
    it "can be instanciated with a string" do
        expect(SirenClient.get(valid_url)).to be_a SirenClient::Entity
    end
    it "can be instanciated with a config hash" do
        expect(SirenClient.get(url: valid_url)).to be_a SirenClient::Entity
    end
  end
end
