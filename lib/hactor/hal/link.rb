require 'ostruct'

module Hactor
  module HAL
    class Link < OpenStruct
      attr_reader :rel, :parent_resource

      def initialize(obj, options)
        @rel = options.fetch(:rel)
        @parent_resource = options.fetch(:context)
        super(obj)
      end
    end
  end
end
