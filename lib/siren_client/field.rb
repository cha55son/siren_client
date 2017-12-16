module SirenClient
  class Field
    attr_reader :payload, :name, :type, :value, :title

    def initialize(data)
      if data.class != Hash
        raise ArgumentError, "You must pass in a Hash to SirenClient::Action.new"
      end
      @payload = data.deep_stringify_keys

      @name  = @payload['name']  || ''
      @type  = @payload['type']  || 'text'
      @value = @payload['value'] || ''
      @title = @payload['title'] || ''
    end
  end
end
