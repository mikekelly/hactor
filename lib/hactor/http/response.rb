require 'delegate'
require 'forwardable'
require 'hactor/hal/document'

module Hactor
  module HTTP
    class Response < Delegator
      extend Forwardable

      attr_reader :codec, :response
      attr_accessor :http_client

      def_delegators :body, :follow,
                            :traverse,
                            :properties,
                            :embedded_resources,
                            :links

      def initialize(response, options={})
        @http_client = options.fetch(:http_client)
        @codec = options.fetch(:codec) { Hactor::HAL::Document }
        @body = options[:body]
        @response = response
      end

      def body
        @body ||= codec.new __getobj__.body,
                            response: self
      end

      def __getobj__
        response
      end
    end
  end
end
