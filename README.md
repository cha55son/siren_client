# SirenClient

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'siren_client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install siren_client

## Usage

api = SirenClient.root(options)
api.links # View the resources you can access

#### Accessing
api.<resource name>.all
api.<resource name>.all.limit(5)
api.<resource name>.find('resource id')
api.<resource name>.first

#### Filtering
api.<resource name>.where(...)
