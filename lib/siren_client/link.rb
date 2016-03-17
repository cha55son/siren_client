module SirenClient
  class Link
    include Modules::WithRawResponse

    attr_accessor :href
    attr_reader :payload, :rels, :title, :type, :config
    
    def initialize(data, config={})
      super()
      if data.class != Hash
        raise ArgumentError, "You must pass in a Hash to SirenClient::Link.new"
      end
      @payload = data
      @config = { format: :json }.merge config 

      @rels  = @payload['rel']   || []
      @href  = @payload['href']  || ''
      @title = @payload['title'] || ''
      @type  = @payload['type']  || ''
    end

    def go
      if next_response_is_raw?
        disable_raw_response
        generate_raw_response(self.href, @config)
      else
        Entity.new(self.href, @config)
      end
    end
  end
end
