require 'ostruct'
require 'addressable/template'

module Hactor
  module HAL
    class Link < OpenStruct
      attr_reader :rel, :parent_resource, :template_class

      def initialize(obj, options)
        @href = obj[:href]
        @rel = options.fetch(:rel)
        @parent_resource = options.fetch(:context)
        @template_class = options[:template_class] || Addressable::Template
        super(obj)
      end

      def href(variables={})
        if templated?
          template_class.new(@href).expand(variables).to_s
        else
          @href
        end
      end

      def templated?
        !!templated
      end
    end
  end
end
