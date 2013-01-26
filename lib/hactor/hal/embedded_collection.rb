require 'forwardable'
require 'hactor/hal/flat_collection'
require 'hactor/hal/resource'
#require 'hactor/hal/null_resource'

module Hactor
  module HAL
    class EmbeddedCollection
      extend Forwardable
      include Enumerable

      attr_reader :hash, :parent, :embedded_class, :flat_collection_class

      def_delegators :all, :each

      def initialize(hash, options)
        #TODO: throw/log parsing error if not hash
        @hash = hash
        @parent = options.fetch(:parent)
        @embedded_class = options[:embedded_class] || Resource
        @flat_collection_class = options[:flat_collection_class] || FlatCollection
      end

      def all
        @all ||= flat_collection_class.new hash,
                                           parent: parent,
                                           item_class: embedded_class
      end

      def find(rel)
        all.find(->{ NullResource.new }) { |resource| resource.rel == rel }
      end
    end
  end
end
