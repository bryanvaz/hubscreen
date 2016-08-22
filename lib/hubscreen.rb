#External Dependancies
require 'active_support'
require 'active_support/core_ext'
require 'faraday'
require 'multi_json'
require 'cgi'

#Rest API Helpers
require "hubscreen/api_request"
require "hubscreen/request"

#Gem Lib Files
require "hubscreen/version"
require "hubscreen/config"
require "hubscreen/exceptions"
require "hubscreen/contact"






module Hubscreen
  def self.configure(config={})
    Hubscreen::Config.configure(config)
  end
end
