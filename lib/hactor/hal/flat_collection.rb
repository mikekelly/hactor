module Hactor
  module HAL
    class FlatCollection < Array
      attr_reader :item_class

      def initialize(hash, options={})
        @item_class = options.fetch(:item_class)
        super flatten(hash)
      end

      private
      def flatten(hash)
        (arr = []).tap do
          hash.each do |rel, value|
            if value.is_a? Array
              arr += value.map { |link| item_class.new(link.merge(rel: rel)) }
            else
              arr.push item_class.new(value.merge(rel: rel))
            end
          end
        end
      end
    end
  end
end
