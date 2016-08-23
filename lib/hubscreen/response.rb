module Hubscreen

  # Hubscreen::Response
  #
  # Parent Class for all Hubscreen response objects. Designed for direct access to the response either through the "raw_hash" which is the hash representation of the JSON response or the "raw_response" which is the OpenStruct representation
  #
  # By default all APIRequests will return a Response object. To disable this, set Hubscreen.configure(encapsulate_response: false)

  class Response
    attr_accessor :raw_hash, :raw_response, :status_code

    def initialize(response_json_hash)
      @raw_hash = response_json_hash
      @raw_response = RecursiveOpenStruct.new(response_json_hash)
    end

    # Prints out the raw response in formatted JSON.
    # This method is primarily used to aid in debugging
    def pretty_response
      JSON.pretty_generate(@raw_hash)
    end

    #Type Cast Helpers
    def contact
      Contact.new(self)
    end
  end
end