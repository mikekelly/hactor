require 'hactor'
require 'hactor/actor'

class UserListActor
  include Hactor::Actor

  def on_200(response)
    user_links = response.body.links.select { |link| link.rel == 'ht:user' }
    puts "There's #{user_links.count} users on haltalk:"
    user_links.each do |link|
      puts "#{link.title} (#{link.href})"
    end
  end
end

class LatestPostActor
  include Hactor::Actor

  def on_200(response)
    puts response.body.embedded_resources.all.first.links.all
  end
end

class HomeActor
  include Hactor::Actor

  def on_200(response)
    response.follow 'ht:users', actor: UserListActor.new
    response.follow 'ht:latest-posts', actor: LatestPostActor.new
  end
end

Hactor.start url: 'http://haltalk.herokuapp.com/', actor: HomeActor.new
