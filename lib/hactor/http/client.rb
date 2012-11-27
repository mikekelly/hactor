require 'hactor/http/response'
require 'faraday'

module Hactor
  module HTTP
    class Client < SimpleDelegator
      attr_reader :response_class, :backend

      def initialize(options={})
        @response_class = options.fetch(:response_class) { Hactor::HTTP::Response }
        @backend = options.fetch(:backend) { Faraday.new }
        super(@backend)
      end

      def follow(link, options = {})
        actor = options.fetch(:actor) { Hactor::NullActor }
        get(url: link.href, actor: actor)
      end

      def get(options)
        url = options.fetch :url
        actor = options.fetch :actor

        response = response_class.new(backend.get(url), http_client: self)

        backend.url_prefix = backend.build_url(url)
        actor.call response
      end
    end
  end
end
