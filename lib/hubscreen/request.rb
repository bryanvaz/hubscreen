module Hubscreen
  class Request
    attr_accessor :api_key, :api_endpoint, :timeout, :proxy, :faraday_adapter, :debug

    DEFAULT_TIMEOUT = 30

    def initialize(api_key: nil, api_endpoint: nil, timeout: nil, proxy: nil, faraday_adapter: nil, debug: false)
      @path_parts = []
      @api_key = api_key || self.class.api_key || Hubscreen::Config.hapikey
      @api_key = @api_key.strip if @api_key
      @api_endpoint = api_endpoint || self.class.api_endpoint || Hubscreen::Config.base_url
      @timeout = timeout || self.class.timeout || DEFAULT_TIMEOUT
      @proxy = proxy || self.class.proxy || ENV['HUBSCREEN_PROXY']
      @faraday_adapter = faraday_adapter || Faraday.default_adapter
      @debug = debug
    end

    def method_missing(method, *args)
      
      @path_parts << method.to_s.downcase
      @path_parts << args if args.length > 0
      @path_parts.flatten!
      self
    end

    def send(*args)
      if args.length == 0
        method_missing(:send, args)
      else
        __send__(*args)
      end
    end

    def path
      @path_parts.join('/')
    end

    def post(params: nil, headers: nil, body: nil)
      APIRequest.new(builder: self).post(params: params, headers: headers, body: body)
    ensure
      reset
    end

    def patch(params: nil, headers: nil, body: nil)
      APIRequest.new(builder: self).patch(params: params, headers: headers, body: body)
    ensure
      reset
    end

    def put(params: nil, headers: nil, body: nil)
      APIRequest.new(builder: self).put(params: params, headers: headers, body: body)
    ensure
      reset
    end

    def get(params: nil, headers: nil)
      APIRequest.new(builder: self).get(params: params, headers: headers)
    ensure
      reset
    end

    def delete(params: nil, headers: nil)
      APIRequest.new(builder: self).delete(params: params, headers: headers)
    ensure
      reset
    end

    protected

    def reset
      @path_parts = []
    end

    class << self
      attr_accessor :api_key, :timeout, :api_endpoint, :proxy

      def method_missing(sym, *args, &block)
        new(api_key: self.api_key, api_endpoint: self.api_endpoint, timeout: self.timeout, proxy: self.proxy).send(sym, *args, &block)
      end
    end
  end
end