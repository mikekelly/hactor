module Hactor
  class NullActor
    def call(response)
      raise "Response had no actor"
    end
  end
end
