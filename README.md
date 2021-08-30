# Tiny URL

tiny_url is a website to create short links

## Setup

#### Environment
* Install ruby 2.5.8, node 12, postgresql
* Dependency installation
```shell
    bundle install
    yarn install
```
#### Database
Create database.yml in config folder (example config: `config/database.yml.enc`)
```shell
    rake db:create
    rake db:migrate
    rails db:seed
```

#### Tests
For test the project uses rspec. In order to run all test you need to run:
```shell
    rspec spec
```

#### Application
For style and future js features I added semantic-ui ui framework. 
There are three routes available to the user.
```http request
1. /
2. /:token
3. /:token/info
```
1. Home page where you can enter your url click ENCRYPT button and it will generate short url for you. In the end it will take a client to the info page(3 route)
2. The short url by which you can access encoded original url. On the background it counts visits to itself.
3. Short url info page where you can find the original url it was created for, the short url create for it and also all visits to the short url.

To run the project use
```shell 
rails s
./bin/webpack-dev-server # Depending on where webpacker installed you can use also webpack-dev-server command

```