module SirenClient
    def self.root(options)
        url = options[:url]
        data = HTTParty.get(url)
        puts data
        Resource.new(data)
    end
end
