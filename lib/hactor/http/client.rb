require 'faraday'
require 'hactor/null_actor'
require 'hactor/http/response'

module Hactor
  module HTTP
    class Client < Delegator
      attr_reader :response_class, :backend

      def initialize(options={})
        @response_class = options[:response_class] || Hactor::HTTP::Response
        @backend = options[:backend] || Faraday.new
      end

      def follow(link, options = {})
        context_url = options.fetch(:context_url)
        actor = options[:actor] || Hactor::NullActor.new
        variables = options[:expand_with]

        href = variables ? link.href(variables) : link.href
        url = context_url.merge(href)

        get(url: url, actor: actor)
      end

      def get(options)
        url = options.fetch :url
        actor = options.fetch :actor

        response = response_class.new(backend.get(url),
                                      http_client: self)
        actor.call response
      end

      def __getobj__
        backend
      end
    end
  end
end
