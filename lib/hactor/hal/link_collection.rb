require 'forwardable'
require 'hactor/hal/flat_collection'
require 'hactor/hal/link'
require 'hactor/hal/null_link'

module Hactor
  module HAL
    class LinkCollection
      extend Forwardable
      include Enumerable

      attr_reader :hash, :parent, :link_class, :flat_collection_class
      def_delegators :all, :each

      def initialize(hash, options={})
        #TODO: throw/log parsing error if not hash
        @hash = hash
        @parent = options.fetch(:parent)
        @link_class = options[:link_class] || Link
        @flat_collection_class = options[:flat_collection_class] || FlatCollection
      end

      def all
        @all ||= flat_collection_class.new hash,
                                           item_class: link_class,
                                           parent: parent

      end

      def find(rel)
        all.find(->{ NullLink.new }) { |link| link.rel == rel }
      end

      def with_rel(rel)
        all.select { |link| link.rel == rel }
      end
    end
  end
end
