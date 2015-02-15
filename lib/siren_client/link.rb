module SirenClient
  class Link
    attr_accessor :href
    attr_reader :payload, :rels, :title, :type, :config
    
    def initialize(data, config={})
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
      Entity.new(self.href, @config)
    end
  end
end
