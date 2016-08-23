require 'pry'
module Hubscreen
  #
  # HubSpot Contacts API
  #
  # {https://developers.hubspot.com/docs/methods/contacts/contacts-overview}
  #
  # This is a convenience object for single Hubspot contact returned by the API 
  #
  # This is a convenience object for handling or retrieving single Hubspot contact returned by the API 
  # These helpers may not be updated as fast as the API. Use at your own risk
  
  class Contact < Hubscreen::Response
    CONTACT_KEYS = [:properties, 
                    :vid, 
                    :email, 
                    :first_name, 
                    :last_name,
                    :hubspot_owner_id]

    CONTACT_ROOT = "v1/contact"
    FIND_BY_VID_PATH = "#{CONTACT_ROOT}/vid" #Note full endpoint is GET /contacts/v1/contact/vid/:contact_id/profile
    FIND_BY_EMAIL_PATH = "#{CONTACT_ROOT}/email" #Note full endpoint is GET /contacts/v1/contact/email/:contact_email/profile
    CREATE_OR_UPDATE_PATH = '#{CONTACT_ROOT}/createOrUpdate/email' #Note full endpoint is POST /contacts/v1/contact/createOrUpdate/email/:contact_email
    UPDATE_PATH = "#{CONTACT_ROOT}/vid" #Note full endpoint is POST /contacts/v1/contact/vid/:contact_id/profile
    UPDATE_BATCH_PATH = "#{CONTACT_ROOT}/batch" # POST /contacts/v1/contact/batch/
    FIND_BY_EMAIL_BATCH_PATH = "#{CONTACT_ROOT}/emails/batch" # Note full endpoint is GET /contacts/v1/contact/emails/batch/:contact_emails


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

    # Convenience Methods
    class << self

      # Find Contact by vid
      # 
      # If Hubspot cannot find the contact, will return the 404 response. Always check for a 200 status code before proceeding
      def find(vid)
        begin
          Hubscreen::Request.new.contacts(FIND_BY_VID_PATH,vid).profile.get.contact
        rescue Hubscreen::RequestError => e
          failure_response = Response.new(e.response)
          failure_response.status_code = e.response[:status_code]
          return failure_response
        end
      end

      # Find Contact by email
      # 
      # If Hubspot cannot find the contact, will return the 404 response. Always check for a 200 status code before proceeding
      def find_by_email(email)
        begin
          Hubscreen::Request.new.contacts(FIND_BY_EMAIL_PATH,email).profile.get.contact
        rescue Hubscreen::RequestError => e
          failure_response = Response.new(e.response)
          failure_response.status_code = e.response[:status_code]
          return failure_response
        end
      end

      # Create New Contact 
      # 
      # {https://developers.hubspot.com/docs/methods/contacts/create_contact}
      #
      # Will return a Contact object representing the new contact
      def create!(email,properties={})
        begin
          params = properties.stringify_keys.merge('email' => email)
          post_data = {properties: Hubscreen::Utils.hash_to_properties(params)}
          Hubscreen::Request.new.contacts(CONTACT_ROOT).post(body: post_data).contact
        rescue Hubscreen::RequestError => e
          
          failure_response = Response.new(e.response)
          failure_response.status_code = e.response[:status_code]
          return failure_response
        end
      end

      # Update New Contact 
      # 
      # {https://developers.hubspot.com/docs/methods/contacts/update_contact}
      #
      # Will return a Contact object representing the updated contact
      def update!(vid,properties={})
        begin
          params = properties.stringify_keys
          post_data = {properties: Hubscreen::Utils.hash_to_properties(params)}
          Hubscreen::Request.new.contacts(UPDATE_PATH,vid).profile.post(body: post_data).contact
        rescue Hubscreen::RequestError => e
          #binding.pry
          failure_response = Response.new(e.response)
          failure_response.status_code = e.response[:status_code]
          return failure_response
        end
      end

      # Upsert Contact  (Create or Update)
      # 
      # {https://developers.hubspot.com/docs/methods/contacts/create_or_update}
      #
      # Will return a Contact object representing the new contact
      def upsert(email,properties={})
        begin
          params = properties.stringify_keys.merge('email' => email)
          post_data = {properties: Hubscreen::Utils.hash_to_properties(params)}
          Hubscreen::Request.new.contacts(CREATE_OR_UPDATE_PATH,email).post(body: post_data).contact
        rescue Hubscreen::RequestError => e
          
          failure_response = Response.new(e.response)
          failure_response.status_code = e.response[:status_code]
          return failure_response
        end
      end
    
      # Batch Methods

      # Create or update a group of contacts
      #
      # {https://developers.hubspot.com/docs/methods/contacts/batch_create_or_update}
      #
      # POST /contacts/v1/contact/batch/
      #
      # From Hubspot:
      # Create a group of contacts or update them if they already exist. Particularly useful for periodic syncs from another contacts database to HubSpot.
      #
      # Performance is best when calls are limited to 100 or fewer contacts.
      #
      # When using this endpoint, please keep in mind that any errors with a single contact in your batch will prevent the entire batch from processing. If this happens, we'll return a 400 response with additional details as to the cause.
      #
      # This method only supports update by vid (vid is mandatory)
      # To use this method, pass in a array of hashes using the following structure:
      #
      # [
      #   {
      #     vid: 5464,
      #     firstname: "George",
      #     lastname: "Henry"
      #   },
      #   {
      #     vid: 5464,
      #     firstname: "Codey",
      #     lastname: "Lang"
      #   }
      # ]      
      def upsert_batch_by_vid(contacts = [])
        begin
          params = []
          contacts.each do |contact|
            params << {'vid': contact[:vid],'properties': Hubscreen::Utils.hash_to_properties(contact.except(:vid).stringify_keys)}
          end
          post_data = params
          Hubscreen::Request.new.contacts(UPDATE_BATCH_PATH).post(body: post_data)
        rescue Hubscreen::RequestError => e
          
          failure_response = Response.new(e.response)
          failure_response.status_code = e.response[:status_code]
          return failure_response
        end
      end

      # Create or update a group of contacts
      #
      # {https://developers.hubspot.com/docs/methods/contacts/batch_create_or_update}
      #
      # POST /contacts/v1/contact/batch/
      #
      # From Hubspot:
      # Create a group of contacts or update them if they already exist. Particularly useful for periodic syncs from another contacts database to HubSpot.
      #
      # Performance is best when calls are limited to 100 or fewer contacts.
      #
      # When using this endpoint, please keep in mind that any errors with a single contact in your batch will prevent the entire batch from processing. If this happens, we'll return a 400 response with additional details as to the cause.
      #
      # This method only supports update by emails (email is manatory)
      # DO NOT PASS VID
      #
      # To use this method, pass in a array of hashes using the following structure:
      #
      # [
      #   {
      #     email: "first@email.com",
      #     firstname: "George",
      #     lastname: "Henry"
      #   },
      #   {
      #     email: "second@email.com",
      #     firstname: "Codey",
      #     lastname: "Lang"
      #   }
      # ]      
      def upsert_batch_by_email(contacts = [])
        begin
          params = []
          contacts.each do |contact|
            params << {'email': contact[:email],'properties': Hubscreen::Utils.hash_to_properties(contact.except(:email).stringify_keys)}
          end
          post_data = params
          Hubscreen::Request.new.contacts(UPDATE_BATCH_PATH).post(body: post_data)
        rescue Hubscreen::RequestError => e
          
          failure_response = Response.new(e.response)
          failure_response.status_code = e.response[:status_code]
          return failure_response
        end
      end

      # Search for a batch of contacts by email address
      #
      # {https://developers.hubspot.com/docs/methods/contacts/get_batch_by_email}
      #
      # GET /contacts/v1/contact/emails/batch/:contact_emails
      #
      # This method will return an array of Contact objects representing the search results
      #
      # If there is a connection error, the status code of the first element will reflect it. Always check this.
      def find_by_emails(emails = [])
        
        begin
          params = {email: emails} # Based on Faraday code >= v0.9
          response = Hubscreen::Request.new.contacts(FIND_BY_EMAIL_BATCH_PATH).get(params: params)
          results = []
          response.raw_hash.each do |key,value|
            results << new(Response.new(value))
          end       
          return results   
        rescue Hubscreen::RequestError => e
          failure_response = Response.new(e.response)
          failure_response.status_code = e.response[:status_code]
          return [failure_response]
        end

      end



    end

  end

end