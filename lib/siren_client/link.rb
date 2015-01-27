module SirenClient
  class Link
    attr_reader :payload, :rels, :href, :title, :type
    
    def initialize(data)
      if data.class != Hash
        raise ArgumentError, "You must pass in a Hash to SirenClient::Link.new"
      end
      @payload = data

      @rels  = @payload['rel']   || []
      @href  = @payload['href']  || ''
      @title = @payload['title'] || ''
      @type  = @payload['type']  || ''
    end

    def go
      Entity.new(self.href)
    end
  end
end
