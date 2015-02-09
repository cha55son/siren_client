module SirenClient
  class Entity
    attr_reader :payload, :classes, :properties, :entities, :rels, 
                :links, :actions, :title, :type, :config, :href


    def initialize(data, config={})
      @config = { format: :json }.merge config 
      if data.class == String
        unless data.class == String && data.length > 0
            raise InvalidURIError, 'An invalid url was passed to SirenClient::Entity.new.'
        end
        begin
          SirenClient.logger.debug "GET #{data}"
          @payload = HTTParty.get(data, @config).parsed_response
        rescue URI::InvalidURIError => e
          raise InvalidURIError, e.message
        rescue JSON::ParserError => e
          raise InvalidResponseError, e.message
        end
      elsif data.class == Hash
          @payload = data
      else
          raise ArgumentError, "You must pass in either a url(String) or an entity(Hash) to SirenClient::Entity.new"
      end
      parse_data
    end

    def [](i)
      @entities[i].href.empty? ? @entities[i] : @entities[i].go rescue nil
    end

    def each(&block)
      @entities.each(&block) rescue nil
    end

    ### Entity sub-links only
    def go
      return if self.href.empty?
      self.class.new(self.href)
    end
    
    def method_missing(method, *args)
      method_str = method.to_s
      return @entities.length if method_str == 'length'
      # Does it match a property, if so return the property value.
      @properties.each do |key, prop|
        return prop if method_str == key
      end
      # Does it match an entity sub-link's class? 
      @entities.each do |ent|
        return ent.go if ent.href && ent.classes.include?(method_str)
      end
      # Does it match a link, if so traverse it and return the entity.
      @links.each do |key, link|
        return link.go if method_str == key
      end
      # Does it match an action, if so return the action.
      @actions.each do |key, action|
        return action if method_str == key
      end
      raise NoMethodError, 'The method does not match a property, action, or link on SirenClient::Entity.'
    end

    private

    def parse_data
      return if @payload.nil?
      @classes    = @payload['class']      || []
      @properties = @payload['properties'] || { }
      @entities   = @payload['entities']   || []
      @entities.map! do |data|
        self.class.new(data)
      end
      @rels  = @payload['rel']   || []
      @links = @payload['links'] || []
      @links.map! do |data|
        Link.new(data)
      end
      # Convert links into a hash
      @links = @links.inject({}) do |hash, link|
        next unless link.rels.length > 0
        # Don't use a rel name if it's generic like 'collection'
        hash_rel = nil
        generic_rels = ['collection']
        link.rels.each do |rel|
          next if generic_rels.include?(rel)
          hash_rel = rel and break
        end
        # Ensure the rel name is a valid hash key
        hash[hash_rel.underscore] = link
        hash
      end
      @actions = @payload['actions'] || []
      @actions.map! do |data|
        Action.new(data, @config)
      end
      # Convert actions into a hash
      @actions = @actions.inject({}) do |hash, action|
        next unless action.name
        hash[action.name.underscore] = action
        hash
      end
      @title = @payload['title'] || ''
      @type  = @payload['type']  || ''
      # Should only be present for entity sub-links.
      @href  = @payload['href']  || ''
    end
  end
end
