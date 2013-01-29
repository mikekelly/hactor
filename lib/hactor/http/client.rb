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

      def follow(link, options)
        context_url = options.fetch(:context_url)

        actor = options[:actor] || Hactor::NullActor.new
        headers = options[:headers]

        url = context_url.merge(link.href(options[:expand_with]))
        response = response_class.new backend.get(url, nil, headers),
                                      http_client: self
        actor.call response
      end

      def traverse(link, options)
        context_url = options.fetch(:context_url)
        method = options.fetch(:method).to_s.downcase

        actor = options[:actor] || Hactor::NullActor.new
        headers = options[:headers]
        body = options[:body]

        url = context_url.merge link.href(options[:expand_with])
        response = response_class.new backend.send(method, url, body, headers),
                                      http_client: self
        actor.call response
      end

      def __getobj__
        backend
      end
    end
  end
end
