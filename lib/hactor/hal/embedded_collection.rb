require 'forwardable'
require 'hactor/hal/flat_collection'
require 'hactor/hal/resource'
#require 'hactor/hal/null_resource'

module Hactor
  module HAL
    class EmbeddedCollection
      extend Forwardable
      include Enumerable

      attr_reader :hash, :embedded_class, :flat_collection_class
      def_delegators :each

      def initialize(hash, options={})
        #TODO: throw/log parsing error if not hash
        @embedded_class = options.fetch(:embedded_class) { Resource }
        @flat_collection_class = options.fetch(:flat_collection_class) { FlatCollection }
        @hash = hash
      end

      def all
        @all ||= flat_collection_class.new(hash, item_class: embedded_class)
      end

      def find_by_rel(rel)
        all.find(->{ NullResource.new }) { |resource| resource.rel == rel }
      end
    end
  end
end
