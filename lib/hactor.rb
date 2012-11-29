require 'hactor/version'
require 'hactor/http/client'
require 'hactor/actor'

module Hactor
  def self.start(options)
    url = options.fetch :url
    actor = options.fetch :actor
    http_client = options.fetch(:http_client) { Hactor::HTTP::Client.new }
    http_client.get(url: url, actor: actor)
  end
end
