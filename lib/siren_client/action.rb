module SirenClient
  class Action
    attr_reader :payload, :name, :classes, :method, :href, :title, :type, :fields, :config

    def initialize(data, config={})
      if data.class != Hash
        raise ArgumentError, "You must pass in a Hash to SirenClient::Action.new"
      end
      @payload = data

      @config  = config
      @name    = @payload['name']   || ''
      @classes = @payload['class']  || []
      @method  = (@payload['method'] || 'GET').downcase
      @href    = @payload['href']   || ''
      @title   = @payload['title']  || ''
      @type    = @payload['type']   || 'application/x-www-form-urlencoded'
      @fields  = @payload['fields'] || []
      @fields.map! do |data|
        SirenClient::Field.new(data)
      end
    end

    def where(params = {})
      options = { headers: {}, query: {}, body: {} }.merge @config
      if @method == 'get'
        options[:query] = params
      else
        options[:body] = params
      end
      options[:headers]['Content-Type'] = @type
      begin
        query = options[:query].empty? ? '' : ('?' + options[:query].to_query)
        SirenClient.logger.debug "#{@method.upcase} #{@href}#{query}"
        options[:headers].each do |k, v|
          SirenClient.logger.debug "  #{k}: #{v}"
        end
        SirenClient.logger.debug '  ' + options[:body].to_query unless options[:body].empty?
        Entity.new(HTTParty.send(@method.to_sym, @href, options).parsed_response)
      rescue URI::InvalidURIError => e
        raise InvalidURIError, e.message
      rescue JSON::ParserError => e
        raise InvalidResponseError, e.message
      end
    end
  end
end
