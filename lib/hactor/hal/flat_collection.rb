module Hactor
  module HAL
    class FlatCollection < Array
      attr_reader :parent, :item_class

      def initialize(hash, options)
        @parent = options.fetch(:parent)
        @item_class = options.fetch(:item_class)
        super flatten(hash)
      end

      private
      def flatten(hash)
        hash ||= {}
        arr = []

        hash.each do |rel, value|
          if value.is_a? Array
            arr += value.map { |obj| item_class.new(obj, rel: rel, context: parent) }
          else
            arr.push item_class.new(value, rel: rel, context: parent)
          end
        end

        arr
      end
    end
  end
end
