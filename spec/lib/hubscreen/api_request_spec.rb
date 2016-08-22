# Based on [hubspot-crm gem](https://github.com/adimichele/hubspot-ruby)


describe Hubscreen::APIRequest do
  let(:api_key) { "demo" }

  before do
    @gibbon = Hubscreen::Request.new(api_key: api_key)
    @api_root = "https://api.hubapi.com"
  end

  #TODO: add more tests

  
end
