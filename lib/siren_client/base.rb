module SirenClient
    def self.root(options)
        url = options[:url]
        data = HTTParty.get(url)
        Resource.new(data)
    end
end
