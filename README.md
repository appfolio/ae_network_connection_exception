# AeNetworkConnectionException

A simple gem that will catch all manner of exceptions related to establishing a network connection and return a more generic error.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ae_network_connection_exception'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ae_network_connection_exception

## Usage

AeNetworkConnectionException.try do
  # your code that will make a network call
end

 # If your network call failed to establise a network connection, an exception of type ```AeNetworkConnectionException::ConnectionNotEstablished``` will be thrown

## Contributing

1. Fork it ( https://github.com/appfolio/ae_network_connection_exception/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
