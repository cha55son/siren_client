module SirenClient
  class Resource
    include HTTParty
    format :json
    # debug_output

    @data = nil

    def initialize(url)
      unless url.class == String && !url.empty?
        raise InvalidURIError, 'An invalid url was passed to SirenClient::Resource.new.'
      end
      self.class.base_uri url
      begin
        @data = self.class.get('/').parsed_response
      rescue URI::InvalidURIError => e
        raise InvalidURIError, e.message
      rescue JSON::ParserError => e
        raise InvalidResponseError, e.message
      end
    end
  end
end
