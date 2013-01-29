require 'hactor'

def start
  Hactor.start url: 'http://haltalk.herokuapp.com/', actor: HomeActor.new
end

class HomeActor
  include Hactor::Actor

  def on_200(response)
    name = 'CHANGE ME'
    user_name = 'PLEASE_CHANGE_ME'

    response.follow 'ht:latest-posts', actor: LatestPostActor.new

    response.traverse('ht:signup', method: 'POST',
                      body: { username: user_name, real_name: name, password: 'blarb' },
                      actor: SignedUpActor.new)

    response.follow('ht:me', expand_with: { name: user_name },
                    actor: ->(res) { puts res.properties })
  end
end

class LatestPostActor
  include Hactor::Actor

  def on_200(response)
    response.embedded_resources.each do |resource|
      puts resource.link('self').href
      puts resource.properties
    end
  end
end

class SignedUpActor
  include Hactor::Actor

  def on_200(response)
    puts "Created an account"
  end

  def on_400(response)
    puts "Failed to create account"
  end
end


start()
