require 'vcr'

VCR.configure do |c|
  c.default_cassette_options = { :record => :none, :erb => true }
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end
