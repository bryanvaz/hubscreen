require 'pry'
module Hubscreen
  #
  # HubSpot Contacts API
  #
  # {https://developers.hubspot.com/docs/methods/contacts/contacts-overview}
  #
  # This is a convenience object for single Hubspot contact returned by the API 
  
  class Contact < Hubscreen::Response
    CONTACT_KEYS = [:properties, 
                    :vid, 
                    :email, 
                    :first_name, 
                    :last_name,
                    :hubspot_owner_id]

    attr_accessor *CONTACT_KEYS

    def initialize(response)
      @raw_hash = response.raw_hash
      @raw_response = response.raw_response
      parse_response
    end

    def parse_response
      @properties = @raw_response.properties
      @vid = @raw_hash["vid"]
      @email = @raw_hash["properties"]["email"]["value"] if @raw_hash["properties"].has_key?("email")
      @first_name = @raw_hash["properties"]["firstname"]["value"] if @raw_hash["properties"].has_key?("firstname")
      @last_name = @raw_hash["properties"]["lastname"]["value"] if @raw_hash["properties"].has_key?("lastname")
      @company = @raw_hash["properties"]["company"]["value"] if @raw_hash["properties"].has_key?("company")
      @hubspot_owner_id = @raw_hash["properties"]["hubspot_owner_id"]["value"] if @raw_hash["properties"].has_key?("hubspot_owner_id")
    end

    def inspect
      "<Hubscreen::Contact vid:#{@vid}, email:'#{@email}', first_name:'#{@first_name}', last_name:'#{@last_name}', company:'#{@company}', hubspot_owner_id:'#{@hubspot_owner_id}', properties:<Not Shown>, raw_response:<Not Shown>, raw_hash:<Not Shown>>"
    end


  end

end