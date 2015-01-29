class TestServer < Sinatra::Base
  CON_1 = <<-EOF
    {  
      "class":["concepts"],
      "rel":["/rels/concepts"],
      "properties":{  
        "text":"barack obama",
        "category":"PERSON"
      },
      "links":[  
        {  
          "rel":["self"],
          "href":"#{@@url}/concepts/1"
        }
      ]
    }
  EOF
  CON_2 = <<-EOF
    {  
      "class":["concepts"],
      "rel":["/rels/concepts"],
      "properties":{  
        "text":"tennessee",
        "category":"LOCATION"
      },
      "links":[  
        {  
          "rel":["self"],
          "href":"#{@@url}/concepts/2"
        }
      ]
    }
  EOF
  post '/concepts/?' do
    query = (request.query_string.length > 0 ? '?' : '') + request.query_string
    <<-EOF
      {
        "class":["concepts","collection"],
        "properties": { "count": 1 },
        "entities": [#{CON_1}],
        "links": [
          {
            "rel": ["self"],
            "href": "#{@@url}/concepts#{query}"
          }
        ]
      }
    EOF
  end
  get '/concepts/?' do
    query = (request.query_string.length > 0 ? '?' : '') + request.query_string
    # search=obama
    if request.params['search']
      <<-EOF
        {
          "class":["concepts","collection"],
          "properties": { "count": 1 },
          "entities": [#{CON_1}],
          "links": [
            {
              "rel": ["self"],
              "href": "#{@@url}/concepts#{query}"
            }
          ]
        }
      EOF
    else
      <<-EOF
        {  
          "class":["concepts","collection"],
          "properties":{  
            "count":2
          },
          "entities":[#{CON_1}, #{CON_2}],
          "links":[  
            {  
              "rel":["self"],
              "href":"#{@@url}/concepts#{query}"
            }
          ]
        }
      EOF
    end
  end
end
