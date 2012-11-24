module Hactor
  module HAL
    class Resource
      RESERVED_PROPERTIES = ['_links', '_embedded']

      attr_reader :state, :link_set_class, :embedded_set_class

      def initialize(state, options={})
        @link_set_class = options.fetch(:link_set_class) { LinkSet }
        @embedded_set_class = options.fetch(:embedded_set_class) { EmbeddedSet }
        @state = state
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
        @links ||= link_set_class.new(state['_links'])
      end

      def embedded_resource(rel)
        embedded_resources.find(rel)
      end

      def embedded_resources
        @embedded_resources ||= embedded_set_class.new(state['_embedded'])
      end
    end
  end
end
