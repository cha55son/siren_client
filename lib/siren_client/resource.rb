module SirenClient
    class Resource
        @data = nil

        def initialize(data)
            parse_data(data)
        end

        def entities

        end

        def actions

        end

        def links(link_name)
            return nil if @data['links'].nil?
            @data['links'].each do |link|
                link['rel'].each do |rel|
                    if rel == link_name
                        data = HTTParty.get(link['href'])
                        return Resource.new(data)
                    end
                end
            end
            raise "No link found with the name: #{link_name}"
        end

        def show(key=nil)
            unless key.nil?
                raise "No valid property named: #{key}" if @data[key.to_s].nil?
                return @data[key.to_s].to_yaml
            end
            @data.to_yaml
        end

        private

        def parse_data(data)
            unless data.class == HTTParty::Response
                raise "Cannot parse response. Invalid object, expecting HTTParty::Response"
            end
            @data = data.parsed_response
        end

        alias_method :describe, :show
    end
end
