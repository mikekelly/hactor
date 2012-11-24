require 'delegate'

module Hactor
  module HTTP
    class Response < SimpleDelegator
      attr_reader :http_client, :codec

      def initialize(response, options={})
        @codec = options.fetch(:codec) { Hactor::HAL::Document }
        @body = options[:body]
        super(response)
      end

      def follow(rel, options={})
        actor = options.fetch(:actor) { Hactor::NullActor.new }
        http_client = options.fetch(:http_client) { Hactor::HTTP::Client.new }

        link = body.link(rel, options)
        http_client.follow(link, actor: actor)
      end

      def body
        @body ||= codec.new(self)
      end
    end
  end
end
