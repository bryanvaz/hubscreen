#External Dependancies
require 'active_support'
require 'active_support/core_ext'
require 'faraday'
require 'multi_json'
require 'cgi'
require 'recursive-open-struct'

#Rest API Helpers
require "hubscreen/api_request"
require "hubscreen/request"
require "hubscreen/response"

#Gem Lib Files
require "hubscreen/utils"
require "hubscreen/version"
require "hubscreen/config"
require "hubscreen/exceptions"
require "hubscreen/contact"






module Hubscreen
  def self.configure(config={})
    Hubscreen::Config.configure(config)
  end
end
