# Hubscreen

Hubscreen is a multi-purpose Ruby wrapper for the [Hubspot CRM API](https://developers.hubspot.com/docs/endpoints), providing developers with low-level access to request-response cycle, or abstract the entire process through ruby objects. Hubscreen is designed to accelerate the integration of Hubspot into a ruby application. As Hubscreen was not initially designed as a foundation for a client facing Hubspot integration (i.e. published to the Hubspot integration library), no OAuth functionality has been provided. 

Documentation for the HubSpot REST API can be found here: https://developers.hubspot.com/docs/endpoints

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hubscreen'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hubscreen

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/hubscreen. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Disclaimer

This project and the code therein was not created by and is not supported by HubSpot, Inc or any of its affiliates.

Hubscreen is provided on an AS-IS basis. Any use of of this code in a business environment should be subjected to additional functional and integration testing prior to release.

## Copyright

Copyright (c) 2016 IMIT Advisory Limited. See LICENSE.txt for further details.

Some libraries are based on the [hubspot-crm gem](https://github.com/adimichele/hubspot-ruby). Refer to code base for details



