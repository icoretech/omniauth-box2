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

## Auth Hash

Example payload from `request.env['omniauth.auth']` (real flow shape, anonymized):

```json
{
  "uid": "123456789",
  "info": {
    "name": "Sample User",
    "email": "sample@example.test"
  },
  "extra": {
    "raw_info": {
      "type": "user",
      "id": "123456789",
      "name": "Sample User",
      "login": "sample@example.test",
      "created_at": "2012-05-09T09:12:30-07:00",
      "modified_at": "2026-03-04T19:21:50-08:00",
      "language": "en",
      "timezone": "Europe/Amsterdam",
      "space_amount": 999999999999999,
      "space_used": 74112195069,
      "max_upload_size": 53687091200,
      "status": "active",
      "job_title": "CEO",
      "phone": "+390000000000",
      "address": "",
      "avatar_url": "https://example.app.box.com/api/avatar/large/123456789",
      "notification_email": null
    }
  }
}
```

Notes:
- `uid` is mapped from `raw_info.id` (as string)
- `info.name` is mapped from `raw_info.name`
- `info.email` is mapped from `raw_info.login`
- `extra.raw_info` is the full `users/me` response

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
