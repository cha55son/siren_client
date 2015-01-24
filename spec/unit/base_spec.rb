require 'helper/spec_helper'

describe SirenClient do
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
      expect { SirenClient.get('http://google.com') }.to raise_error(SirenClient::InvalidResponseError)
    end
  end
  # Remainder will be tested in live spec
end
