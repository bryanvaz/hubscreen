#Load Gem files
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

#Load Test files
$LOAD_PATH.unshift(File.dirname(__FILE__))


#Set Folder Locations
RSPEC_ROOT = File.dirname(__FILE__)
GEM_ROOT = File.expand_path("..", RSPEC_ROOT)

#Gem Requires
require 'hubscreen'

#Testing Requires
require 'rspec'
require 'webmock/rspec'
require 'vcr'
require 'pry'
#require 'rr'


#Load up Fixtures
VCR.configure do |c|
  c.cassette_library_dir = "#{RSPEC_ROOT}/fixtures/vcr_cassettes"
  c.hook_into :webmock
end


RSpec.configure do |config|
  #config.mock_with :rr

  config.after(:each) do
    Hubscreen::Config.reset!
  end

  #TODO: Add VCR for API Requests Response tests
  config.around(:each, live: true) do |example|
    VCR.turn_off!
    WebMock.disable!
    example.run
    WebMock.enable!
    VCR.turn_on!
  end

  
end