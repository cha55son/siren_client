require 'sinatra'
require 'json'

class TestServer < Sinatra::Base
  @@url = 'http://localhost:9292'
  @@content_type = 'application/vnd.siren+json'

  get '/?' do
    headers['Content-type'] = @@content_type
    <<-EOF
      {
        "properties": {
          "page": 1,
          "name": "Test 1"
        },
        "links": [
          {
            "rel": ["self"],
            "href":"#{@@url}/"
          },
          {
            "rel": ["concepts"], 
            "href":"#{@@url}/concepts",
            "title": "Concepts"
          },
          { "rel": ["messages"],
            "href": "#{@@url}/messages",
            "title":"Messages"
          }
        ]
      }
    EOF
  end
  get '/concepts/?' do
    headers['Content-type'] = @@content_type
    <<-EOF
      {  
        "class":["concepts","collection"],
        "properties":{  
          "count":2
        },
        "entities":[  
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
          },
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
        ],
        "links":[  
          {  
            "rel":["self"],
            "href":"#{@@url}/concepts"
          }
        ]
      }
    EOF
  end
end
