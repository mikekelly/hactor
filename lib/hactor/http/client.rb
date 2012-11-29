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
        actor = options.fetch(:actor)
        context_url = options.fetch(:context_url)

        url = context_url.merge(link.href)
        get(url: url, actor: actor)
      end

      def get(options)
        url = options.fetch :url
        actor = options.fetch :actor

        response = response_class.new(backend.get(url),
                                      http_client: self)
        actor.call response
      end
    end
  end
end
