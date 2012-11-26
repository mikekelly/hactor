module Hactor
  module HAL
    class LinkCollection
      attr_reader :hash

      def initialize(hash, options={})
        #TODO: throw/log parsing error if not hash
        link_class = options.fetch(:link_class) { Link }
        @hash = hash
      end

      def find(rel, options={})
        hash.fetch(rel.to_s) { NullLink }
      end

      def all

      end
    end
  end
end
