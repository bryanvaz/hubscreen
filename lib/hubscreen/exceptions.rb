# Based on [hubspot-crm gem](https://github.com/adimichele/hubspot-ruby)

module Hubscreen
  class RequestError < StandardError
    attr_accessor :response

    def initialize(message, response)
      message += "\n" if message
      me = super("#{message}Response body: #{response}",)
      me.response = response
      return me
    end
  end

  class ConfigurationError < StandardError; end
  class MissingInterpolation < StandardError; end
  class ContactExistsError < RequestError; end
  class InvalidParams < StandardError; end
  class ApiError < StandardError; end
end
