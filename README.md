## Synopsis

Open Source repo for https://www.improvcoaches.com

## About

I originally built the site as a resource for improv students and coaches while I was involved in the New York City community.  While I can still maintain the site's public deployment, development on it has slowed and as such I've decided to open source it.  This was also a "Learn Rails!" project for myself, so please keep that in mind as you judge my code. :)

## Requirements
- Docker

The development container currently uses Ruby 3.4.10, Rails 8.1, Node.js 24,
PostgreSQL 17, and Redis 7.4.

## Environment Variables
The application uses the following environment variables:

- `FACEBOOK_APP_ID` - Facebook App ID for OAuth
- `FACEBOOK_SECRET` - Facebook App Secret for OAuth
- `DATABASE_URL` - Database connection URL
- `REDISTOGO_URL` - Redis connection URL
- `GOOGLE_TAG_ID` - Google Analytics tag ID
- `RECAPTCHA_SITE_KEY` - Google reCAPTCHA v3 site key
- `RECAPTCHA_SECRET_KEY` - Google reCAPTCHA v3 secret key


## Running

- Run `docker compose build`
- Run `docker compose run --rm web bin/rails db:prepare`
- Run `docker compose up`. The server is available at localhost:3000.
- Access the Rails console with `docker compose run --rm web bin/rails console`
- Run the test suite with `docker compose run --rm -e RAILS_ENV=test web bin/rails test`

## Create an Admin account
- Open a console.
- `User.first.update!(is_admin: true)` to set up that account as the admin of your local site.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
