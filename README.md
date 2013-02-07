# Sinatra Template [![Build Status](https://secure.travis-ci.org/shell/sinatra-template.png)](https://secure.travis-ci.org/shell/sinatra-template.png) [![Code Climate](https://codeclimate.com/github/shell/sinatra-template.png)](https://codeclimate.com/github/shell/sinatra-template)

## About
  Recently I found myself doing a very simple services for my cliens with Sinatra. There is a lot of guides, tutorials and FAQs around the internet. But it seems that there is no good Sinatra template with testing coverate, basic files structure, etc. So I made one.

## App
  * HTTP basic authentication
  * ActiveRecord orm
  * Sqlite3 for development, Mysql2 for production
  * 2 very basic but associated models
  * HAML, blueprint, jquery
  * User and Admin interfaces
  * Scroller with products
  * Full rake tasks for db management(hacked _sinatra-activerecord_ gem)
  * **Testing suite out of the box(RSpec)**
  * Some essential Rails helpers
  * Ready for deploy with passenger(_/config/setup\_load\_paths.rb_)

  You can switch environments with RACK_ENV=test
  If you have old version of rake installed in gemset, you need to prepend all rake commands with `bundle exec`

  Some prefer to extract controllers, models, helpers in corresponding folders and split them over files. It is a matter of taste, bit if you have a lot of files, consider using Rails instead.


## HTML
  * HAML
  * jquery
  * blueprint
  * basic forms for models
  * kitten placeholders - everything is better with bluetooth(or Kittens)

## Helpers
  * link\_to - it is not full copy of Rails's link_to, this version produces only anchor tag with parameters
  * in\_groups\_of - iteration over collection by groups
  * options\_for\_select

## Rake

    $ rake -T

    rake db:create
    rake db:create_migration
    rake db:drop
    rake db:migrate
    rake db:reset
    rake db:rollback
    rake db:seed


## Installation

    $ git clone https://github.com/shell/sinatra-template.git
    $ cd sinatra-template
    $ rake db:create && rake db:migrate
    $ ruby app.rb

## Testing
  Testing suite include overall application behaviour(/spec/app_spec.rb) and model specific testing(products_spec.rb, categories_spec.rb).
  Specific test include unit testing for model and actions tests for app

  Do not forget to create and migrate testing database before:

    $ RACK_ENV=test rake db:create
    $ RACK_ENV=test rake db:migrate


  Run tests once

    $ rspec spec/

  Autotest friendly

    $ ./autotest

  Testing coverate generated with _SimpleCov_ flavor

      $ open coverage/index.html

## Deploy

  Deploy it as regular rack/rails application. Just point root to /app/public and set RACK_ENV variable

## Todo

  * additional essential rails helpers
  * might need to use a Spork

## Author
  Vladimir Penkin