# SirenClient [![Build Status](https://travis-ci.org/cha55son/siren_client.svg)](https://travis-ci.org/cha55son/siren_client) [![Coverage Status](https://coveralls.io/repos/cha55son/siren_client/badge.svg)](https://coveralls.io/r/cha55son/siren_client)

A simple client for traversing Siren APIs. Not sure what Siren is? View the spec here: https://github.com/kevinswiber/siren.

## Usage

Grabbing the root of the API.

```ruby
require 'siren_client'

# The simplest form
root = SirenClient.get('http://siren-api.example.com')

# Advanced usage
root = SirenClient.get({
  url: 'http://siren-api.example.com',
  headers: { "Accept": "application/json", ... },
  basic_auth: { username: 'person', password: '1234' },
  timeout: 5,
  ... # Refer to https://github.com/jnunemaker/httparty/blob/master/lib/httparty.rb#L45
      # For more options.
})
```

There are four main parts to an [Entity](https://github.com/kevinswiber/siren#entity) in Siren. (properties, entities, links, and actions) To make your life a little easier SirenClient will try to pick one of the four items given a method name. Otherwise you can access the data directly.

### Properties

```ruby
# If color was a property on the root you could do something like this:
root.color 
# or 
root.properties['color']
```

### Entities

Since entities are usually the most important, SirenClient provides enumerable support to obtain them.

```ruby
# Will grab the entity as if root was an array.
root[x] 
# or
root.entities[x] # This is an array
# Will iterate through all the entities on the root.
root.each do |entity|
  # do something
end
# With full enumerable support entities work similarly to arrays
root.map { |entity| ... }
root.select { |entity| ... }
root.find { |entity| ... }
# You can view all the enumerable methods here: http://ruby-doc.org/core-2.0.0/Enumerable.html
```

Entities also provide the method `.search` for searching across sub-entities' classes, rels, and hrefs (sub-links only).

```ruby
root.search("messages") # => Array<SirenClient::Entity>
root.search(/(messages|concepts)/) # => Array<SirenClient::Entity>
```

#### Entity sub-links

If the root contains an entity that is an [embedded link](https://github.com/kevinswiber/siren#embedded-link) you can call it based on it's class name. This will also execute the link's href and return you the entity.

```ruby
root.embedded_link_class_name
root.messages # For example
```

### Links

```ruby
# If you know the link's name you could do something like this:
root.concepts
# or
root.links['concepts'].go
```

### Actions

```ruby
# Again, if you know the action's name you can do this:
root.filter_concepts.where(name: 'github', status: 'active')
# or
root.actions['filter_concepts'].where(...)
```

#### Fields

Actions have fields that are used to make the request when you use `.where`. To see those fields you can do this:

```ruby
action = root.actions[0]
action.fields.each do |field|
  puts "#Field: {field.name}, #{field.type}, #{field.value}, #{field.title}"
end
```

## Development

Run the following commands to start development:

```bash
bundle install
bundle exec guard 
# This will open a CLI that watches files for changes.
```

I've included `byebug` as a development dependency and you may use it as well.

## Thanks To

Kevin Swiber - For creating the Siren spec and giving this project meaning.
