require 'byebug' if RUBY_VERSION > '2' && RUBY_PLATFORM != "java"
require 'siren_client'
require 'coveralls'
Coveralls.wear!
Dir["./spec/support/shared_examples/*.rb"].sort.each {|f| require f}

RSpec.configure do |config|
  # Ensure we only use `expect` and not `should`.
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def siren_body
  {
    'class' => ['graphs', 'collection'],
    'properties' => {
      'page' => 1,
      'limit' => 20
    },
    'entities' => [
      {
        'class' => ['graphs'],
        'rel' => ['/rels/graphs'],
        'properties' => {
          'name' => 'test1'
        },
        'entities' => [
          {
            'class' => ['messages', 'collection'],
            'rel' => ['/rels/messages'],
            'href' => 'http://localhost/graphs/test1/messages'
          },
          {
            'class' => ['concepts', 'collection'],
            'rel' => ['/rels/concepts'],
            'href' => 'http://localhost/graphs/test2/concepts'
          },
          {
            # Just to test the underscore transformation
            'class' => ['user-preferences', 'collection'],
            'rel' => ['/rels/user-preferences'],
            'href' => 'http://localhost/graphs/user/preferences'
          }
        ],
        'links' => [
          {
            'rel' => ['self'],
            'href' => 'http://localhost/graphs/test1'
          }
        ]
      }
    ],
    'actions' => [
      {
        'name' => 'filter_concepts',
        'method' => 'GET',
        'href' => 'http://localhost/graphs/test1/concepts',
        'title' => 'Get an optionally filtered list of Concepts',
        'type' => 'application/x-www-form-urlencoded',
        'fields' => [
          {
            'name' => 'limit',
            'title' => 'Max number of results in each page',
            'type' => 'NUMBER',
            'required' => false
          },
          {
            'name' => 'page',
            'title' => 'Page number, starting at 1',
            'type' => 'NUMBER',
            'required' => false
          },
          {
            'name' => 'search',
            'title' => 'Keyword search',
            'type' => 'TEXT',
            'required' => true
          }
        ]
      },
      {
        'name' => 'filter-messages',
        'method' => 'GET',
        'href' => 'http://localhost/graphs/test1/messages',
        'title' => 'Get an optionally filtered list of Messages',
        'type' => 'application/x-www-form-urlencoded',
        'fields' => [
          {
            'name' => 'limit',
            'title' => 'Max number of results in each page',
            'type' => 'NUMBER',
            'required' => false
          },
          {
            'name' => 'page',
            'title' => 'Page number, starting at 1',
            'type' => 'NUMBER',
            'required' => false
          },
          {
            'name' => 'search',
            'title' => 'Keyword search',
            'type' => 'TEXT',
            'required' => true
          }
        ]
      }
    ],
    'links' => [
      {
        'rel' => ['self'],
        'href' => 'http://localhost/graphs?limit=1&page=1&order_by=name'
      },
      {
        'rel' => ['prev-page'],
        'href' => 'http://localhost/graphs?limit=1&page=0&order_by=name'
      },
      {
        'rel' => ['next'],
        'href' => 'http://localhost/graphs?limit=1&page=2&order_by=name'
      }
    ]
  }
end
