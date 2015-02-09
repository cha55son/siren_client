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
  describe '.logger(before)' do
    it 'is a standard ruby logger instance' do
      expect(SirenClient.logger).to be_a Logger
    end
  end
  describe '.logger=' do
    it 'raise an error if it does not respect the logger interface' do
      expect { SirenClient.logger = "error" }.to raise_error
    end
    it 'accepts an instance that respects the logger interface' do
      SirenClient.logger = Logger.new(STDOUT)
      SirenClient.logger.level = Logger::WARN
      expect(SirenClient.logger).to be_a Logger
    end
  end
  describe '.logger(after)' do
    it 'responds to .info(str)' do
      expect(SirenClient.logger.respond_to?(:info)).to eq(true)
    end
    it 'responds to .warn(str)' do
      expect(SirenClient.logger.respond_to?(:warn)).to eq(true)
    end
    it 'responds to .error(str)' do
      expect(SirenClient.logger.respond_to?(:error)).to eq(true)
    end
  end
  # Remainder will be tested in live spec
end
