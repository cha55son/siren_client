module SirenClient
  def self.get(options)
    if options.is_a? String
      Entity.new(options)
    elsif options.is_a? Hash
      url = options[:url] || options['url']
      raise ArgumentError, "You must supply a valid url to SirenClient.get" unless url
      Entity.new(url, options)
    else
      raise ArgumentError, 'You must supply either a string or hash to SirenClient.get'
    end
  end
end
