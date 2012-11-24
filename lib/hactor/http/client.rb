require 'hactor/http/response'

module Hactor
  module HTTP
    class Client
      attr_reader :response_class, :backend

      def initialize(options)
        @response_class = options.fetch(:response_class) { Hactor::HTTP::Response }
        @backend = options.fetch(:backend) { Faraday.new }
      end

      def get(options)
        url = options.fetch :url
        actor = options.fetch :actor
        response = response_class.new(backend.get url)
        actor.call response
      end
    end
  end
end
