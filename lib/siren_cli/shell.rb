module SirenCLI
    class Shell
        def initialize
            root = get_root
            @ent_stack = []
            @ent = root
            display_entity
            loop_input
        end
        def loop_input
            while input = Readline.readline('(ent)> ', true).chomp
                exit if ['exit', 'quit'].include?(input.downcase)
                case input.downcase
                when 'b', 'back'
                    if @ent_stack.length == 0
                        puts "Already at the root entity."
                        next
                    end
                    @ent = @ent_stack.pop 
                    display_entity
                    next
                when 's', 'summary'
                    display_entity
                    next
                end
                begin
                    ent = @ent
                    val = eval input
                    if val.is_a? SirenClient::Entity
                        @ent_stack << @ent
                        @ent = val
                        display_entity
                    else
                        puts val unless input.empty?
                    end
                rescue SyntaxError => e
                    puts "#{e.class} - #{e.message}"
                rescue StandardError => e
                    puts "#{e.class} - #{e.message}"
                end
            end
        end
        
        def get_root
            @root_url = Readline.readline('Root URL> ', true).chomp
            SirenClient.get(@root_url)
        end

        def display_entity
            puts "----------------------------------"
            puts "  Entity: #{get_href(@ent.links['self'] && @ent.links['self'].href)}"
            puts "----------------------------------"
            puts "  Properties: #{@ent.properties.keys.length}"
            @ent.properties.each do |k, v|
                val = v.to_s
                ind = @ent.properties.keys[-1] == k ? '└──' : '├──'
                puts "    #{ind} #{k}: #{val.length > 80 ? val[0..80] + '...' : val}"
            end
            puts "  Entities: #{@ent.entities.length}"
            @ent.entities.each_with_index do |e, i|
                ind = @ent.entities[-1] == e ? '└──' : '├──'
                is_collection = e.classes.include?('collection')
                puts "    #{ind} [#{i}] #{e.properties.to_s.length > 80 ? e.properties.to_s[0..80] + '...' : e.properties}" unless is_collection
                puts "    #{ind} [#{i}] #{e.rels[0]}: #{get_href(e.href)}" if is_collection
            end
            puts "  Links: #{@ent.links.length}"
            @ent.links.each do |k, link|
                ind = @ent.links.keys[-1] == k ? '└──' : '├──'
                puts "    #{ind} #{link.rels[0]}: #{get_href(link.href)}"
            end
            puts "  Actions: #{@ent.actions.length}"
            @ent.actions.each do |k, action|
                ind = @ent.actions.keys[-1] == k ? '└──' : '├──'
                puts "    #{ind} #{action.name}: #{action.method.upcase} #{action.fields.map { |f| f.name + '[' + f.type + ']' }.join(', ')}"
            end
        end

        def get_href(href)
            return 'Unknown' unless href
            return href unless @root_url
            trimmed = href.gsub(@root_url, '')
            trimmed.empty? ? '/' : trimmed
        end
    end
end
