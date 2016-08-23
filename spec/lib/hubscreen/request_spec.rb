# Based on [hubspot-crm gem](https://github.com/adimichele/hubspot-ruby)
require 'securerandom'


describe Hubscreen::Request do
  let(:api_key) { "demo" }
  let(:config){ {hapikey: SecureRandom.hex(10), base_url: SecureRandom.hex(10), portal_id: SecureRandom.random_number(100)} }

  before do
    @hubscreen = Hubscreen::Request.new(api_key: api_key)
    @api_root = "https://api.hubapi.com/"
  end

  #TODO: add more tests
  it "initializes with request" do
    r_api_key = SecureRandom.hex(10)
    r_api_endpoint = SecureRandom.hex(10)
    r_timeout = SecureRandom.random_number(100)
    r_proxy = SecureRandom.hex(10)
    request_builder = Hubscreen::Request.new(api_key: r_api_key, api_endpoint: r_api_endpoint, timeout: r_timeout, proxy: r_proxy)

    expect(request_builder.api_key).to eq(r_api_key)
    expect(request_builder.api_endpoint).to eq(r_api_endpoint)
    expect(request_builder.timeout).to eq(r_timeout)
    expect(request_builder.proxy).to eq(r_proxy)    
  end

  it "initializes to defaults" do
    Hubscreen::Config.configure config
    request_builder = Hubscreen::Request.new
    
    expect(request_builder.api_key).to eq(config["hapikey"])
    expect(request_builder.api_endpoint).to eq(config["base_url"])
  end

  it "builds request using method missing" do
    request_builder = Hubscreen::Request.new.path_level1.path_level2("path@level3")
    expect(request_builder.path).to eq("path_level1/path_level2/path@level3")
  end


  
end
