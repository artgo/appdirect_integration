# AppdirectIntegration
[![Build Status](https://travis-ci.org/artgo/appdirect_integration.svg?branch=master)](https://travis-ci.org/artgo/appdirect_integration)

Integration with AppDirect masrketplace.

## Installation

Add this line to your application's Gemfile:

```ruby
   gem 'appdirect_integration'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install appdirect_integration

## Usage

Register with AppDirect (free): https://www.appdirect.com/developers/register

Create an application and and copy your consumer key and consumer secret.

Add appdirect_integration gem to Gemfile
```ruby
   gem 'appdirect_integration'
```

Add Generate your Order scaffold
```ruby
   rails g scaffold Order
```

Setup Order model to work with AppDirect and generate migrations
```ruby
   rails g appdirect_integration Order
```

Generate configuration
```ruby
   rails g appdirect_integration:install
```
which will generate `config/initializers/appdirect.rb` file.

Edit initializer config/initializers/appdirect.rb and specify your consumer key, consumer secret, and Order model there.

gem will automatically create (new) and save your Order ActiveRecord/Mongoid object at runtime.

the list of supported fields:
* `company_uuid`
* `company_name`
* `company_email`
* `company_phone`
* `company_website`
* `company_country`
* `user_uuid`
* `user_open_id`
* `user_email`
* `user_first_name`
* `user_last_name`
* `user_language`
* `user_address_full_name`
* `user_address_company_name`
* `user_address_phone`
* `user_address_phone_extension`
* `user_address_fax`
* `user_address_fax_extension`
* `user_address_street1`
* `user_address_street2`
* `user_address_city`
* `user_address_state`
* `user_address_zip`
* `user_address_country`
* `user_address_pobox`
* `user_address_pozip`
* `status`
* `edition`
* `marketplace_url`
* `pricing_duration`
* `quantity`
* `unit`
* `quantity2`
* `unit2`
* `quantity3`
* `unit3`
* `all_data`
* `order_items` - should be mentioned as `has_many: order_items` for ActiveRecord or `embeds_many: order_items` for Mongoid

Fields for order_items OrderItem:
* `unit`
* `quantity`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/artgo/appdirect_integration.

## CHANGELOG

See [here](CHANGELOG.md).

## Documentation

See AppDirect API documentation [here](http://info.appdirect.com/developers/docs/getting-started/introduction).