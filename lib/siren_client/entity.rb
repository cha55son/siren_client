module SirenClient
  class Entity
    include HTTParty
    format :json
    # debug_output
    attr_reader :payload, :classes, :properties, :entities, :rels, 
                :links, :actions, :title, :href, :type


    def initialize(data)
      if data.class == String
        unless data.class == String && data.length > 0
            raise InvalidURIError, 'An invalid url was passed to SirenClient::Entity.new.'
        end
        self.class.base_uri data
        begin
            @payload = self.class.get('/').parsed_response
        rescue URI::InvalidURIError => e
            raise InvalidURIError, e.message
        rescue JSON::ParserError => e
            raise InvalidResponseError, e.message
        end
      elsif data.class == Hash
          @payload = data
      else
          raise ArgumentError, "You must pass in either a data(String) or an entity(Hash) to SirenClient::Entity.new"
      end
      parse_data()
    end

    private

    def parse_data
      return if @payload.nil?
      @classes = @payload['class'] || []
      @properties = @payload['properties'] || { }
      @entities = @payload['entities'] || []
      @entities.map! do |hash|
        Entity.new(hash)
      end
      @rels = @payload['rel'] || []
      @links = @payload['links'] || []
      @links.map! do |hash|
        Link.new(hash)
      end
      @actions = @payload['actions'] || []
      @actions.map! do |action|
        Action.new(hash)
      end
      @title = @payload['title'] || ''
      @href = @payload['href'] || ''
      @type = @payload['type'] || ''
    end
  end
end
