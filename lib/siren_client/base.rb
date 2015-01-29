module SirenClient
  # Add a logger that gets passed in from an outside source
  # or default to a standard logger. This will allow different
  # setups i.e. java logging to log wherever/however they wish.
  @@logger = Logger.new(STDOUT)
  @@logger.level = Logger::INFO
  @@logger.progname = 'SirenClient.' + SirenClient::VERSION
  def self.logger; @@logger; end
  def self.logger=(log)
    unless  log.respond_to?(:debug) &&
            log.respond_to?(:info)  &&
            log.respond_to?(:warn)  &&
            log.respond_to?(:error) &&
            log.respond_to?(:fatal)
      raise InvalidLogger, "The logger object does not respond to [:debug, :info, :warn, :error, :fatal]."
    end
    @@logger = log
    @@logger.progname = 'SirenClient.' + SirenClient::VERSION
  end

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
