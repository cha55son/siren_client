module SirenClient
  class Action
    attr_reader :payload, :name, :classes, :method, :href, :title, :type, :fields

    def initialize(data)
      if data.class != Hash
        raise ArgumentError, "You must pass in a Hash to SirenClient::Action.new"
      end
      @payload = data

      @name    = @payload['name']   || ''
      @classes = @payload['class']  || []
      @method  = @payload['method'] || 'GET'
      @href    = @payload['href']   || ''
      @title   = @payload['title']  || ''
      @type    = @payload['type']   || ''
      @fields  = @payload['fields'] || []
      @fields.map! do |data|
        SirenClient::Field.new(data)
      end
    end
  end
end
