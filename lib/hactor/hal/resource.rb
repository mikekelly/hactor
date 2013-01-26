require 'forwardable'
require 'hactor/hal/link_collection'
require 'hactor/hal/embedded_collection'

module Hactor
  module HAL
    class Resource
      extend Forwardable

      RESERVED_PROPERTIES = ['_links', '_embedded']

      attr_reader :rel, :state, :http_client, :context
      attr_accessor :link_collection_class, :embedded_collection_class

      def_delegators :context, :http_client, :base_url

      def initialize(state, options)
        @rel = options.fetch(:rel)
        @context = options.fetch(:context)
        @state = state
      end

      def follow(rel, options={})
        http_client.follow link(rel), options_in_context(options)
      end

      def traverse(rel, options={})
        http_client.traverse link(rel), options_in_context(options)
      end

      def properties
        @properties ||= state.reject { |k,v|
          RESERVED_PROPERTIES.include? k
        }
      end

      def link(rel, options={})
        links.find(rel)
      end

      def links
        @links ||= link_collection_class.new state['_links'],
                                             parent: self
      end

      def embedded_resource(rel)
        embedded_resources.find(rel)
      end

      def embedded_resources
        @embedded_resources ||= embedded_collection_class.new state['_embedded'],
                                                              parent: self
      end

      def embedded_collection_class
        @embedded_collection_class ||= EmbeddedCollection
      end

      def link_collection_class
        @link_collection_class ||= LinkCollection
      end

      private

      def options_in_context(options)
        options.merge context_url: context.base_url
      end
    end
  end
end
