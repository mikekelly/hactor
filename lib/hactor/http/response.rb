require 'delegate'

module Hactor
  module HTTP
    class Response < SimpleDelegator
      attr_reader :http_client, :codec

      def initialize(response, options={})
        @codec = options.fetch(:codec) { Hactor::HAL::Document }
        @http_client = options.fetch(:http_client) { Hactor::HTTP::Client.new }
        @body = options[:body]
        super(response)
      end

      def follow(rel, options={})
        actor = options.fetch(:actor) { Hactor::NullActor }
        uri = body.link_uri(rel, options)
        http_client.get(url: uri, actor: actor)
      end

      def body
        @body ||= codec.new(self)
      end
    end
  end
end
