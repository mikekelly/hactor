# Hactor

Here's an example of how to use Hactor:


```ruby
require 'hactor'

def run_example
  Hactor.start url: 'http://haltalk.herokuapp.com/', actor: HomeActor.new
end

class HomeActor
  include Hactor::Actor

  def on_200(response)
    response.follow 'ht:latest-posts', actor: LatestPostActor.new

    name = 'My Name'
    user_name = 'my_user_name'

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

  def on_201(response)
    puts "Created an account"
  end

  def on_400(response)
    puts "Failed to create account"
  end
end


run_example()
```

The following demonstrates the various things an actor can do with a response:

```ruby
class SomeActor
  include Hactor::Actor

  def on_200(response)
    # Follow the rel_name link
    response.follow rel_name, actor: some_actor

    # Expand link's URI template with query_vars and follow that
    response.follow rel_name, expand_with: query_vars , actor: some_actor

    # Traverse the link with some_method, some_headers, and some_body
    response.traverse rel_name,
                      method: some_method,
                      headers: some_headers, 
                      body: some_string,
                      actor: some_actor
  end
end

Hactor.start url: some_entry_point_url, actor: SomeActor.new
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
