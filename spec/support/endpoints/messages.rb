class TestServer < Sinatra::Base
  MSG_1 = <<-EOF
    {
      "class":["messages"],
      "rel":["/rels/messages"],
      "properties":{
        "id": 1,
        "text":"This is message one"
      },
      "links":[
        {
          "rel":["self"],
          "href":"#{@@url}/messages/1"
        }
      ],
      "actions": [{
        "name": "update message",
        "method": "PUT",
        "href": "#{@@url}/messages/1",
        "title": "Update the text of the message",
        "type": "text/plain"
      }]
    }
  EOF
  MSG_2 = <<-EOF
    {
      "class":["messages"],
      "rel":["/rels/messages"],
      "properties":{
        "id": 2,
        "text":"This is message two"
      },
      "links":[
        {
          "rel":["self"],
          "href":"#{@@url}/messages/2"
        }
      ],
      "actions": [{
        "name": "update message",
        "method": "PUT",
        "href": "#{@@url}/messages/2",
        "title": "Update the text of the message",
        "type": "text/plain"
      }]
    }
  EOF
  put '/messages/:id' do
    if request.content_type == 'text/plain' &&
       request.body.read == 'this is the new message'
      MSG_1
    else
      halt 404
    end
  end
  get '/messages/?' do
    query = (request.query_string.length > 0 ? '?' : '') + request.query_string
    # search=obama
    if request.params['search']
      <<-EOF
        {
          "class":["messages","collection"],
          "properties": { "count": 1 },
          "entities": [#{MSG_1}],
          "links": [
            {
              "rel": ["self"],
              "href": "#{@@url}/messages#{query}"
            }
          ]
        }
      EOF
    else
      <<-EOF
        {
          "class":["messages","collection"],
          "properties":{
            "count":2
          },
          "entities":[#{MSG_1}, #{MSG_2}],
          "links":[
            {
              "rel":["self"],
              "href":"#{@@url}/messages#{query}"
            }
          ]
        }
      EOF
    end
  end
end
