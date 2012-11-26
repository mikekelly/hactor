require 'hactor/hal/link_collection'

module Hactor
  module HAL
    class Resource
      RESERVED_PROPERTIES = ['_links', '_embedded']

      attr_reader :state, :link_collection_class, :embedded_collection_class

      def initialize(state, options={})
        @link_collection_class = options.fetch(:link_collection_class) { LinkCollection }
        @embedded_collection_class = options.fetch(:embedded_collection_class) { EmbeddedCollection }
        @state = state
      end

      def properties
        @properties ||= state.reject { |k,v|
          RESERVED_PROPERTIES.include? k
        }
      end

      def link(rel, options={})
        links.find_by_rel(rel)
      end

      def links
        @links ||= link_collection_class.new(state['_links'])
      end

      def embedded_resource(rel)
        embedded_resources.find(rel)
      end

      def embedded_resources
        @embedded_resources ||= embedded_collection_class.new(state['_embedded'])
      end
    end
  end
end
