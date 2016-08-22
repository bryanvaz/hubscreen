# Based on [hubspot-crm gem](https://github.com/adimichele/hubspot-ruby)

describe Hubscreen::Config do
  describe "#configure" do
    let(:config){ {hapikey: "demo", base_url: "http://api.hubapi.com/v2", portal_id: "62515"} }
    subject{ Hubscreen::Config.configure(config) }

    it "changes the hapikey config" do
      expect{ subject }.to change(Hubscreen::Config, :hapikey).to("demo")
    end

    it "changes the base_url" do
      expect{ subject }.to change(Hubscreen::Config, :base_url).to("http://api.hubapi.com/v2")
    end

    it "sets a default value for base_url" do
      expect(Hubscreen::Config.base_url).to eq("https://api.hubapi.com")
    end

    it "sets a value for portal_id" do
      expect{ subject }.to change(Hubscreen::Config, :portal_id).to("62515")
    end
  end

  describe "#reset!" do
    let(:config){ {hapikey: "demo", base_url: "http://api.hubapi.com/v2", portal_id: "62515"} }
    before{ Hubscreen::Config.configure(config) }
    subject{ Hubscreen::Config.reset! }
    it "clears out the config" do
      subject
      expect(Hubscreen::Config.hapikey).to be_nil
      expect(Hubscreen::Config.base_url).to eq("https://api.hubapi.com")
      expect(Hubscreen::Config.portal_id).to be_nil
    end
  end

  describe "#ensure!" do
    subject{ Hubscreen::Config.ensure!(:hapikey, :base_url, :portal_id)}
    before{ Hubscreen::Config.configure(config) }

    context "with a missing parameter" do
      let(:config){ {hapikey: "demo", base_url: "http://api.hubapi.com/v2"} }
      it "should raise an error" do
        expect { subject }.to raise_error Hubscreen::ConfigurationError
      end
    end

    context "with all requried parameters" do
      let(:config){ {hapikey: "demo", base_url: "http://api.hubapi.com/v2", portal_id: "62515"} }
      it "should not raise an error" do
        expect { subject }.to_not raise_error
      end
    end
  end
end
