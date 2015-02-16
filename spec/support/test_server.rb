require 'sinatra'
require 'json'

class TestServer < Sinatra::Base
  @@url = 'http://localhost:9292'

  use Rack::Auth::Basic, "SirenClient Test API" do |username, password|
    username == 'admin' and password == '1234'
  end

  before do
    content_type 'application/vnd.siren+json'
  end
end

# Require all the endpoint files that build the api.
Dir[File.expand_path(File.dirname(__FILE__)) + "/endpoints/*.rb"].each {|file| require file }
