module SirenClient
  class Entity
    include HTTParty
    format :json
    # debug_output
    attr_reader :payload, :classes, :rels, :properties


    def initialize(url)
      unless url.class == String && url.length > 0
        raise InvalidURIError, 'An invalid url was passed to SirenClient::Entity.new.'
      end
      self.class.base_uri url
      begin
        @payload = self.class.get('/').parsed_response
      rescue URI::InvalidURIError => e
        raise InvalidURIError, e.message
      rescue JSON::ParserError => e
        raise InvalidResponseError, e.message
      end

      @classes = @payload['class'] || []
      @rels = @payload['rel'] || []
      @properties = @payload['properties'] || { }
    end
  end
end
