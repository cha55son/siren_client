module SirenClient
  class Entity
    include Enumerable
    include Modules::WithRawResponse

    attr_accessor :href
    attr_reader :payload, :classes, :properties, :entities, :rels,
                :links, :actions, :title, :type, :config


    def initialize(data, config={})
      super()
      @config = { format: :json }.merge config
      if data.class == String
        unless data.class == String && data.length > 0
          raise InvalidURIError, 'An invalid url was passed to SirenClient::Entity.new.'
        end
        begin
          resp = generate_raw_response(:get, data, @config)
          if resp.parsed_response.nil?
            raise InvalidResponseError.new "Response could not be parsed. Code=#{resp.code} Message=\"#{resp.message}\" Body=#{resp.body}"
          end
          @payload = resp.parsed_response
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

    # Execute an entity sub-link if called directly
    # otherwise just return the entity.
    def [](i)
      if @entities[i].href.empty?
        @entities[i]
      else
        if next_response_is_raw?
          disable_raw_response
          @entities[i].with_raw_response.go
        else
          @entities[i].go
        end
      end
    end

    def each(&block)
      @entities.each(&block) rescue nil
    end

    def search(criteria)
      return false unless criteria
      if criteria.is_a? String
        return entities.select do |ent|
          true if ent.classes.include?(criteria) ||
                  ent.rels.include?(criteria) ||
                  ent.href == criteria
        end
      elsif criteria.is_a? Regexp
        return entities.select do |ent|
          true if ent.classes.any? { |klass| criteria.match(klass) } ||
                  ent.rels.any? { |rel| criteria.match(rel) } ||
                  criteria.match(ent.href)
        end
      end
    end

    ### Entity sub-links only
    def go
      return if self.href.empty?
      if next_response_is_raw?
        disable_raw_response
        generate_raw_response(:get, self.href, @config)
      else
        self.class.new(self.href, @config)
      end
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
        if ent.href && (ent.classes.map { |c| underscore_name c }).include?(underscore_name(method_str))
          if next_response_is_raw?
            disable_raw_response
            return ent.with_raw_response.go
          else
            return ent.go
          end
        end
      end
      # Does it match a link, if so traverse it and return the entity.
      @links.each do |key, link|
        if method_str == underscore_name(key)
          if next_response_is_raw?
            disable_raw_response
            return link.with_raw_response.go
          else
            return link.go
          end
        end
      end
      # Does it match an action, if so return the action.
      @actions.each do |key, action|
        return action if method_str == underscore_name(key)
      end
      raise NoMethodError, "The method \"#{method_str}\" does not match a property, action, or link on SirenClient::Entity."
    end

    private

    def underscore_name(str)
      str.underscore.gsub(' ', '_')
    end

    def parse_data
      return if @payload.nil?
      @classes    = (@payload['class']      || []).clone
      @properties = (@payload['properties'] || { }).clone
      @entities   = (@payload['entities']   || []).clone
      @entities.map! do |data|
        self.class.new(data, @config)
      end
      @rels  = (@payload['rel']   || []).clone
      @links = (@payload['links'] || []).clone
      @links.map! do |data|
        Link.new(data, @config)
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
        hash[hash_rel] = link
        hash
      end
      @actions = (@payload['actions'] || []).clone
      @actions.map! do |data|
        Action.new(data, @config)
      end
      # Convert actions into a hash
      @actions = @actions.inject({}) do |hash, action|
        next unless action.name
        hash[action.name] = action
        hash
      end
      @title = @payload['title'] || ''
      @type  = @payload['type']  || ''
      # Should only be present for entity sub-links.
      @href  = @payload['href']  || ''
    end
  end
end
