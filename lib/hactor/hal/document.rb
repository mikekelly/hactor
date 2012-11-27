require 'delegate'
require 'json'
require 'hactor/hal/resource'

module Hactor
  module HAL
    class Document < SimpleDelegator
      attr_reader :body, :resource_class

      def initialize(body, options={})
        @resource_class = options.fetch(:resource_class) { Resource }
        @body = JSON.parse(body)
        super(root_resource)
      end

      def root_resource
        @root_resource ||= resource_class.new(body)
      end
    end
  end
end

