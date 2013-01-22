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

The following demonstrates the various things an actor can do with a response:

```ruby
class SomeActor
  include Hactor::Actor

  def on_200(response)
    # Follow the rel_name link
    response.follow rel_name, actor: some_actor
    # Expand link's URI template with query_vars and follow that
    response.follow rel_name, query: query_vars , actor: some_actor
    # Traverse the link with some_method, some_headers, and some_body
    response.traverse rel_name, method: some_method, headers: some_headers,  body: some_string, actor: some_actor
    # In each case, the response produce will be handled by some_actor
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
