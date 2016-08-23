# Based on [hubspot-crm gem](https://github.com/adimichele/hubspot-ruby)

require 'logger'

module Hubscreen
  class Config

    CONFIG_KEYS = [:hapikey, :base_url, :portal_id, :logger, :encapsulate_response]
    DEFAULT_LOGGER = Logger.new(STDOUT)
    DEFAULT_BASE_URL = "https://api.hubapi.com/"
    DEFAULT_RESPONSE_ENCAPSULATION = true

    class << self
      attr_accessor *CONFIG_KEYS

      def configure(config)
        config.stringify_keys!
        @hapikey = config["hapikey"]
        @base_url = config["base_url"] || DEFAULT_BASE_URL
        @portal_id = config["portal_id"] #not currenty used
        @logger = config['logger'] || DEFAULT_LOGGER
        @encapsulate_response = config['encapsulate_response'] || DEFAULT_RESPONSE_ENCAPSULATION
        self
      end

      def reset!
        @hapikey = nil
        @base_url = DEFAULT_BASE_URL
        @portal_id = nil
        @logger = DEFAULT_LOGGER
        @encapsulate_response = DEFAULT_RESPONSE_ENCAPSULATION
      end

      def ensure!(*params)
        params.each do |p|
          raise Hubscreen::ConfigurationError.new("'#{p}' not configured") unless instance_variable_get "@#{p}"
        end
      end

      def standard_base_url
        return DEFAULT_BASE_URL
      end
    end



    reset!
  end
end
