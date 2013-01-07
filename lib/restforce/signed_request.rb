require 'openssl'
require 'base64'
require 'json'

module Restforce
  class SignedRequest
    attr_accessor :signature, :payload, :client_secret

    # Public: Initializes and decodes the signed request
    #
    # message       - The POST message containing the signed request from Salesforce.
    # client_secret - The oauth client secret used to encrypt the message.
    #
    # Returns the parsed JSON context.
    def self.decode(message, client_secret)
      new(message, client_secret).decode
    end

    def initialize(message, client_secret)
      self.client_secret = client_secret
      self.signature, self.payload = message.split('.')
      self.signature = Base64.decode64(self.signature)
    end

    # Public: Decode the signed request.
    #
    # Returns the parsed JSON context.
    # Returns nil if the signed request is invalid.
    def decode
      return nil if signature != hmac
      JSON.parse(Base64.decode64(payload))
    end
    
  private

    def hmac
      @hmac = OpenSSL::HMAC.digest(digest, client_secret, payload)
    end

    def digest
      @digest = OpenSSL::Digest::Digest.new('sha256')
    end

  end
end
