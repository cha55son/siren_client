module SirenClient
  # Add a logger that gets passed in from an outside source
  # or default to a standard logger. This will allow different
  # setups i.e. java logging to log wherever/however they wish.

  def self.get(options)
    if options.is_a? String
      Entity.new(options)
    elsif options.is_a? Hash
      raise ArgumentError, "You must supply a valid url to SirenClient.get" unless options[:url]
      HTTP.headers = options[:headers] if options.is_a?(Hash) && options[:headers]
      Entity.new(options)    
    else
      raise ArgumentError, 'You must supply either a string or hash to SirenClient.get'
    end
  end
end
