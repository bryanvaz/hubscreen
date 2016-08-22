# Based on [gibbon gem](https://github.com/amro/gibbon)

module Hubscreen
  class APIRequest

    # A new API request must pass in a Hubscreen::Request Object 
    def initialize(builder: nil)
      @request_builder = builder
    end

    def post(params: nil, headers: nil, body: nil)
      validate_api_key

      begin
        response = self.rest_client.post do |request|
          configure_request(request: request, params: params, headers: headers, body: MultiJson.dump(body))
        end
        parse_response(response.body)
      rescue => e
        handle_error(e)
      end
    end

    def patch(params: nil, headers: nil, body: nil)
      validate_api_key

      begin
        response = self.rest_client.patch do |request|
          configure_request(request: request, params: params, headers: headers, body: MultiJson.dump(body))
        end
        parse_response(response.body)
      rescue => e
        handle_error(e)
      end
    end

    def put(params: nil, headers: nil, body: nil)
      validate_api_key

      begin
        response = self.rest_client.put do |request|
          configure_request(request: request, params: params, headers: headers, body: MultiJson.dump(body))
        end
        parse_response(response.body)
      rescue => e
        handle_error(e)
      end
    end

    def get(params: nil, headers: nil)
      validate_api_key

      begin
        response = self.rest_client.get do |request|
          configure_request(request: request, params: params, headers: headers)
        end
        parse_response(response.body)
      rescue => e
        handle_error(e)
      end
    end

    def delete(params: nil, headers: nil)
      validate_api_key

      begin
        response = self.rest_client.delete do |request|
          configure_request(request: request, params: params, headers: headers)
        end
        parse_response(response.body)
      rescue => e
        handle_error(e)
      end
    end

    #protected

    # Convenience accessors

    def api_key
      @request_builder.api_key
    end

    def api_endpoint
      @request_builder.api_endpoint
    end

    def timeout
      @request_builder.timeout
    end

    def proxy
      @request_builder.proxy
    end

    def adapter
      @request_builder.faraday_adapter
    end

    # Helpers

    def handle_error(error)
      error_params = {}

      begin
        if error.is_a?(Faraday::Error::ClientError) && error.response
          error_params[:status_code] = error.response[:status]
          error_params[:raw_body] = error.response[:body]
          
          parsed_response = MultiJson.load(error.response[:body])

          if parsed_response
            error_params[:body] = parsed_response
            error_params[:title] = parsed_response["title"] if parsed_response["title"]
            error_params[:detail] = parsed_response["detail"] if parsed_response["detail"]
          end

        end
      rescue MultiJson::ParseError
      end

      error_to_raise = Hubscreen::RequestError.new(error.message, error_params)

      raise error_to_raise
    end

    def configure_request(request: nil, params: nil, headers: nil, body: nil)
      if request
        request.params.merge!(params) if params
        request.headers['Content-Type'] = 'application/json'
        request.headers.merge!(headers) if headers
        request.body = body if body
        request.options.timeout = self.timeout
      end
    end

    def rest_client
      client = Faraday.new(self.api_url, proxy: self.proxy) do |faraday|
        faraday.response :raise_error
        faraday.adapter adapter
        if @request_builder.debug
          faraday.response :logger, ::Logger.new(STDOUT), bodies: true
        end
      end
      # Hubspot expects the API key in the Query Params (WTF!!)
      client.params['hapikey'] = self.api_key
      #client.basic_auth('hapikey', self.api_key)
      client
    end

    def parse_response(response_body)
      parsed_response = nil

      if response_body && !response_body.empty?
        begin
          parsed_response = MultiJson.load(response_body)
        rescue MultiJson::ParseError
          error = ApiError.new("Unparseable response: #{response_body}")
          error.title = "UNPARSEABLE_RESPONSE"
          error.status_code = 500
          raise error
        end
      end

      parsed_response
    end

    def validate_api_key
      api_key = self.api_key
      api_endpoint = self.api_endpoint
      unless api_key
        raise Hubscreen::ApiError, "You must set an api_key prior to making a call"
      end
      unless api_endpoint
        raise Hubscreen::ApiError, "You must set an api_endpoint prior to making a call"
      end
    end

    def api_url
      base_api_url + @request_builder.path
    end

    def base_api_url
      @request_builder.api_endpoint 
    end

  end
end