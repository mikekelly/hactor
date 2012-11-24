module Hactor
  module HAL
    class Resource
      RESERVED_PROPERTIES = ['_links', '_embedded']

      attr_reader :state

      def initialize(state, options={})
        @state = state
      end

      def properties
        @properties ||= state.reject { |k,v|
          RESERVED_PROPERTIES.include? k
        }
      end

      def link(rel, options={})

      end

      def link_uri(*args)
        link(*args).href
      end

      def links(options={})
        link_set_class = options.fetch(:link_set_class) { LinkSet }
        @links ||= link_set_class.new(state['_links'])
      end

      def embedded_resource

      end

      def embedded_resources(options={})
        embedded_set_class = options.fetch(:embedded_set_class) { EmbeddedSet }
        @embedded_resources ||= embedded_set_class.new(state['_embedded'])
      end
    end
  end
end
