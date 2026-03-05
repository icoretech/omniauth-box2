# OmniAuth Box2 Strategy

[![Test](https://github.com/icoretech/omniauth-box2/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/icoretech/omniauth-box2/actions/workflows/test.yml?query=branch%3Amain)
[![Gem Version](https://img.shields.io/gem/v/omniauth-box2.svg)](https://rubygems.org/gems/omniauth-box2)

This gem provides an [OmniAuth](https://github.com/omniauth/omniauth) strategy for Box OAuth2.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-box2'
```

Then run:

```bash
bundle install
```

## Usage

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :box, ENV.fetch('BOX_CLIENT_ID'), ENV.fetch('BOX_CLIENT_SECRET')
end
```

Auth hash fields exposed by this strategy:
- `uid` from Box user `id`
- `info[:name]` from Box user `name`
- `info[:email]` from Box user `login`
- `extra['raw_info']` full Box user payload

## Provider Endpoints

The strategy uses current Box OAuth and API endpoints:
- Authorize URL: `https://account.box.com/api/oauth2/authorize`
- Token URL: `https://api.box.com/oauth2/token`
- User info URL: `https://api.box.com/2.0/users/me`

## Development

```bash
bundle install
bundle exec rake lint
bundle exec rake test_unit
bundle exec rake test_rails_integration
```

## License

MIT License. See `LICENSE.txt`.
