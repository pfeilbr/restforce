require 'faraday'
require 'faraday_middleware'
require 'json'

require 'restforce/version'
require 'restforce/config'

module Restforce
  autoload :SignedRequest, 'restforce/signed_request'
  autoload :Collection,    'restforce/collection'
  autoload :Middleware,    'restforce/middleware'
  autoload :UploadIO,      'restforce/upload_io'
  autoload :SObject,       'restforce/sobject'
  autoload :Client,        'restforce/client'
  autoload :Mash,          'restforce/mash'

  AuthenticationError = Class.new(StandardError)
  UnauthorizedError   = Class.new(StandardError)

  class << self
    # Alias for Restforce::Client.new
    #
    # Shamelessly pulled from https://github.com/pengwynn/octokit/blob/master/lib/octokit.rb
    def new(options = {})
      Restforce::Client.new(options)
    end

    # Public: Decodes a signed request received from Force.com Canvas.
    #
    # message       - The POST message containing the signed request from Salesforce.
    # client_secret - The oauth client secret used to encrypt the message.
    #
    # Returns the Hash context if the message is valid.
    def decode_signed_request(message, client_secret)
      SignedRequest.decode(message, client_secret)
    end
  end

  # Add .tap method in Ruby 1.8
  module CoreExtensions
    def tap
      yield self
      self
    end
  end
  Object.send :include, Restforce::CoreExtensions unless Object.respond_to? :tap
end
