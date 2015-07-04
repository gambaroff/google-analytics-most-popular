$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
Dir["./spec/support/*.rb"].sort.each { |f| require f}
require 'most-popular'
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)