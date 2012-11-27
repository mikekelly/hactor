module Hactor
  module Actor
    def call(response)
      self.send "on_#{response.status}".to_s, response
    end
  end
end
