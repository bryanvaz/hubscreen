# Based on [hubspot-crm gem](https://github.com/adimichele/hubspot-ruby)
require 'securerandom'

describe Hubscreen::APIRequest do
  let(:api_key) { "demo" }

  before do
    @hubscreen = Hubscreen::Request.new(api_key: api_key)
    @api_root = "https://api.hubapi.com/"
  end

  #TODO: add more tests
  

  it "API Client responds with exeception for no api key" do
    @hubscreen = Hubscreen::Request.new(api_key: api_key)
    
    #set the path
    @hubscreen.path1

    @hubscreen.api_key = nil
    expect(@hubscreen.api_key).to be_nil
    expect{@hubscreen.get}.to raise_error(Hubscreen::ApiError)
    @hubscreen.api_key = ""
    expect(@hubscreen.api_key).to eq("")
    expect{@hubscreen.get}.to raise_error(Hubscreen::ApiError)
  end
  it "API Client responds with exeception for no endpoint" do
    @hubscreen = Hubscreen::Request.new(api_key: api_key)
    @hubscreen.api_endpoint = nil
    expect(@hubscreen.api_endpoint).to be_nil
    expect{@hubscreen.get}.to raise_error(Hubscreen::ApiError)

    @hubscreen.api_endpoint = ""
    expect(@hubscreen.api_endpoint).to eq("")
    expect{@hubscreen.get}.to raise_error(Hubscreen::ApiError)
  end


end
