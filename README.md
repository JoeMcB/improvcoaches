## Synopsis

Open Source repo for https://www.improvcoaches.com

## About

I originally built the site as a resource for improv students and coaches while I was involved in the New York City community.  While I can still maintain the site's public deployment, development on it has slowed and as such I've decided to open source it.  This was also a "Learn Rails!" project for myself, so please keep that in mind as you judge my code. :)

## Requirements
- Docker


## Running

- Run `docker build . -t improvcoaches`
- Run `docker-compose run web rake db:create`
- Run `docker-compose run web rake db:seed`
- Run `docker-compose up`.  Server is available at localhost:300
- Access the Rails consolt with `docker-compose run web rails c`

## Create an Admin account
- Open a console.
- `User.first.update_attributes(is_admin: true)` to set up that account as the admin of your local site.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request