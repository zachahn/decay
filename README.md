# Decay

Decay is an enum library that makes sure that each case is handled.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decay"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install decay

## Usage

### ActiveRecord / ActiveModel

This is only compatible with Rails versions 5.0 and up since it uses the
Attributes API.

```ruby
require "decay/rails"

class Order < ActiveRecord::Base
  extend Decay::ActiveEnum

  active_enum payment: %i[fully_paid void refund]
end

order = Order.new

order.fully_paid!
order.payment # => #<Order::PAYMENT:0x007fd9c59329d8 @value=:fully_paid>
order.payment = Order::PAYMENT[:void]
order.payment = :refund

order.payment
  .case
  .when(:fully_paid) { do_something }
  .when(:void) { do_something_else }
  .when(:refund) { do_something_else_else }
  .result

order.payment
  .case
  .when(:fully_paid) { do_something }
  .result # => Raises error since there are unhandled cases
```

### Plain Ruby objects

```ruby
require "decay"

class GreenEggsAndHam
  extend Decay::Enum

  enum with: %i[mouse fox goat]
  enum where: %i[here there house box car tree train boat]
  enum environment: %i[dark rain]
end

guy = GreenEggsAndHam.new

guy.with = GreenEggsAndHam::WITH[:mouse]
guy.with.value # => :mouse

guy.where = :here

guy.where
  .case
  .when(:here) {}
  # ...
  .result
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/zachahn/decay.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
