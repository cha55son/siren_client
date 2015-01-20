module SirenClient
  class StandardError < ::StandardError
  end
  class ConfigError < StandardError
  end
  class InvalidURIError < StandardError
  end
  class InvalidResponseError < StandardError
  end
end
