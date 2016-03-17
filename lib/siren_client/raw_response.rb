module SirenClient
  class RawResponse
    def initialize(http_res)
        unless http_res.class == HTTParty::Response
          raise InvalidResponseError, "SirenClient::RawResponse expects a HTTParty::Response instance."
        end
        @response = http_res
    end

    def body
      @response.body 
    end

    def code
      @response.code
    end

    def message
      @response.message.strip
    end

    def headers
      @response.headers
    end
  end
end
