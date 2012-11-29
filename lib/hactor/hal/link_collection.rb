require 'forwardable'
require 'hactor/hal/flat_collection'
require 'hactor/hal/link'
#require 'hactor/hal/null_link'

module Hactor
  module HAL
    class LinkCollection
      extend Forwardable
      include Enumerable

      attr_reader :hash, :link_class, :flat_collection_class
      def_delegators :all, :each

      def initialize(hash, options={})
        #TODO: throw/log parsing error if not hash
        @link_class = options.fetch(:link_class) { Link }
        @flat_collection_class = options.fetch(:flat_collection_class) { FlatCollection }
        @hash = hash
      end

      def all
        @all ||= flat_collection_class.new(hash, item_class: link_class)
      end

      def find_by_rel(rel)
        all.find(->{ NullLink.new }) { |link| link.rel == rel }
      end
    end
  end
end
