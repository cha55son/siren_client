module SirenClient
  def self.get(options)
    unless options.class == String || options.class == Hash
      raise ConfigError, 'You must supply either a string or hash to SirenClient.get'
    end
    # Ensure the url is a string
    url = options if options.class == String
    # If it's not a string then check the hash 
    url = options[:url] if url.nil? && !options[:url].nil?
    raise ConfigError, "You must supply a valid url to SirenClient.get" if url.nil?
    Entity.new(url)    
  end
end
