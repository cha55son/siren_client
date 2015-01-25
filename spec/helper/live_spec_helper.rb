require 'rack'
require 'helper/spec_helper'
require 'support/test_server'

# Start a local rack server to serve up dummy data.
server_thread = Thread.new do
  Rack::Handler::WEBrick.run(
    TestServer.new,
    :Port => 9292,
    :AccessLog => [],
    :Logger => WEBrick::Log::new("/dev/null", 7)
  )
end
sleep(1) # wait a sec for the server to be boot

 RSpec.configure do |config|
   config.after(:suite) { 
     # server_thread.shutdown rescue nil
     server_thread.kill
   }
end
