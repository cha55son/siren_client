module SirenClient
  class Action
    include Modules::WithRawResponse

    attr_accessor :href
    attr_reader :payload, :name, :classes, :method, :title, :type, :fields, :config

    def initialize(data, config={})
      super()
      if data.class != Hash
        raise ArgumentError, "You must pass in a Hash to SirenClient::Action.new"
      end
      @payload = data

      @config = { format: :json }.merge config
      @name    = @payload['name']   || ''
      @classes = @payload['class']  || []
      @method  = (@payload['method'] || 'GET').downcase
      @href    = @payload['href']   || ''
      @title   = @payload['title']  || ''
      @type    = @payload['type']   || 'application/x-www-form-urlencoded'
      @fields  = @payload['fields'] || []
      @fields.map! do |field_data|
        SirenClient::Field.new(field_data)
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
        resp = generate_raw_response(@method, self.href, options)
        if next_response_is_raw?
          disable_raw_response
          resp
        else
          if resp.parsed_response.nil?
            raise InvalidResponseError.new "Response could not be parsed. Code=#{resp.code} Message=\"#{resp.message}\" Body=#{resp.body}"
          end
          Entity.new(resp.parsed_response, @config)
        end
      rescue URI::InvalidURIError => e
        raise InvalidURIError, e.message
      rescue JSON::ParserError => e
        raise InvalidResponseError, e.message
      end
    end
    # `.submit` should be used with actions that
    # don't require any parameters, for readability.
    alias_method :submit, :where
  end
end
