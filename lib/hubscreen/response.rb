module Hubscreen

  # Hubscreen::Response
  #
  # Parent Class for all Hubscreen response objects. Designed for direct access to the response either through the "raw_hash" which is the hash representation of the JSON response or the "raw_response" which is the OpenStruct representation
  #
  # By default all APIRequests will return a Response object. To disable this, set Hubscreen.configure(encapsulate_response: false)

  class Response
    attr_accessor :raw_hash, :raw_response

    def initialize(response_json_hash)
      @raw_hash = response_json_hash
      @raw_response = OpenStruct.new(response_json_hash)
    end
  end
end