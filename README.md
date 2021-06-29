# Zoo stats
[![Build Status](https://travis-ci.org/zooniverse/zoo-stats-api-graphql.svg?branch=master)](https://travis-ci.org/zooniverse/zoo-stats-api-graphql)

#### API

The stats service has a GraphQL API, https://graphql.org/ and a RESTful API.

See [the API docs](./docs/API.md) for more details

#### Getting Started

1. Clone the repository `git clone https://github.com/zooniverse/zoo_stats_api_graphql`.

0. Install Docker from the appropriate link above.

0. `cd` into the cloned folder.

0. Run `docker-compose build` to build the containers Panoptes API container. You will need to re-run this command on any changes to `Dockerfile.dev` (note the dev dockerfile, production is `Dockerfile`)

0. Create and run the application containers with `docker-compose up`

0. If the above step reports a missing database error, kill the docker-compose process or open a new terminal window in the current directory and then to setup the database run

Setup the development database without any data

``` sh
docker-compose run --rm zoo_stats bundle exec rake db:setup:development
```

Setup the development database with example data

``` sh
docker-compose run --rm zoo_stats bundle exec rake db:setup:seed:development
```

0. Open up the application in your browser at http://localhost:3000

Once all the above steps complete you will have a working copy of the checked out code base. Keep your code up to date and rebuild the image on any code or configuration changes.

Note: You will need to re-install the gem dependencies for the application if you modify the Gemfile
    * Run: `docker-compose run --rm zoo_stats bundle install`

#### Testing

1. Setup the test environment and database
    * Run: `docker-compose run --rm -e RAILS_ENV=test zoo_stats bundle exec rake db:create`

0. Run the tests
    * Run: `docker-compose run -T --rm -e RAILS_ENV=test zoo_stats bundle exec rspec`

0. Get a console to interactively run / debug tests
    * Run: `docker-compose run --rm -e RAILS_ENV=test zoo_stats bash`
    * Then in the container run: `bin/rspec` to run the test suite using Spring code loader (speeds up iterative testing)

### Setup Docker and Docker Compose

* Docker
  * [OS X](https://docs.docker.com/installation/mac/) - Docker Machine
  * [Ubuntu](https://docs.docker.com/installation/ubuntulinux/) - Docker
  * [Windows](http://docs.docker.com/installation/windows/) - Boot2Docker

* [Docker Compose](https://docs.docker.com/compose/)

#### Thanks

This product includes GeoLite2 data created by MaxMind, available from http://www.maxmind.com.

[![pullreminders](https://pullreminders.com/badge.svg)](https://pullreminders.com?ref=badge)
