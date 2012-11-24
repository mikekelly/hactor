require 'forwardable'
require 'json'
require 'hactor/hal/resource'

module Hactor
  module HAL
    class Document
      extend Forwardable

      attr_reader :body, :resource_class
      def_delegators :root_resource, :link, :links, :embedded_resource, :embedded_resources

      def initialize(body, options={})
        @resource_class = options.fetch(:resource_class) { Resource }
        @body = JSON.parse(body)
      end

      def root_resource
        @root_resource ||= resource_class.new(body)
      end
    end
  end
end

