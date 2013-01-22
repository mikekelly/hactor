require 'delegate'
require 'hactor/hal/document'

module Hactor
  module HTTP
    class Response < SimpleDelegator
      attr_reader :http_client, :codec

      def initialize(response, options={})
        @http_client = options.fetch(:http_client)
        @codec = options.fetch(:codec) { Hactor::HAL::Document }
        @body = options[:body]
        super(response)
      end

      def follow(rel, options={})
        actor = options.fetch(:actor) { Hactor::NullActor.new }
        client = options.fetch(:http_client) { http_client }

        link = body.link(rel)
        client.follow(link, context_url: env[:url], actor: actor)
      end

      def body
        @body ||= codec.new(__getobj__.body)
      end
    end
  end
end
