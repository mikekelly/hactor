require 'hactor/version'
require 'hactor/http/client'
require 'hactor/null_actor'
require 'hactor/actor'

module Hactor
  def self.start(options)
    url = options.fetch :url

    actor = options[:actor] || NullActor.new
    http_client = options[:http_client] || Hactor::HTTP::Client.new

    http_client.get(url, actor: actor)
  end
end
