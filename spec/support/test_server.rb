require 'sinatra'
require 'json'

class TestServer < Sinatra::Base
  @@url = 'http://localhost:9292'

  before do
    content_type 'application/vnd.siren+json'
  end
end

Dir[__dir__ + "/endpoints/*.rb"].each {|file| require file }
