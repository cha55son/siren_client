module SirenClient
  class Link
    attr_reader :payload, :rels, :href, :title, :type, :config
    
    def initialize(data, config={})
      if data.class != Hash
        raise ArgumentError, "You must pass in a Hash to SirenClient::Link.new"
      end
      @payload = data
      @config = config

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
