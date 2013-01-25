module Hactor
  class NullActor
    def call(response)
      raise "Response has no actor:\n#{response.inspect}"
    end
  end
end
