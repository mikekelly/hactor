# Hactor

Here's an example of how to use Hactor:


```ruby
require 'hactor'

class UserListActor
  include Hactor::Actor

  def on_200(response)
    user_links = response.body.links.select { |link| link.rel == 'ht:user' }
    user_links.each do |link|
      puts "#{link.title} (#{link.href})"
    end
  end
end

class LatestPostActor
  include Hactor::Actor

  def on_200(response)
    puts response.body.embedded_resources.first.links.all
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
```

## Installation

Add this line to your application's Gemfile:

    gem 'hactor'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hactor

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
