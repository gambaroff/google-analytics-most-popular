require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.before_record do |i|
    i.response.body.replace 'body here'
    i.response.headers.delete_if{|key, value| key == "P3p" || "Etag" || "Set-Cookie"}
    i.request.headers.delete_if{|key, value| key == "Authorization"}
  end
end
