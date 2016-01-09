## Synopsis

Open Source repo for http://www.improvcoaches.com

## About

I originally built the site as a resource for improv students and coaches while I was involved in the New York City community.  While I can still maintain the site's public deployment, development on it has slowed and as such I've decided to open source it.  This was also a "Learn Rails!" project for myself, so please keep that in mind as you judge my code. :)

## Requirements
- Postgres (Available for OSX at http://postgresapp.com/)
- Redis


## Running

- Run `bundle install`
- Configure a `.env` file
	```
	REDISTOGO_URL='redis://localhost:6379'
	FACEBOOK_KEY=<Optional for Facebook Login>
	FACEBOOK_SECRET=<Optional for Facebook Login>
	```
- Initialize the Database
	```
	rake db:create
	rake db:seed
	```
- Start the server with `foreman start`
- Create an account either in the via traditional signup.
- Run `rails c`
- `User.first.update_attributes(is_admin: true)` to set up that account as the admin of your local site.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request