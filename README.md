# autoscout24_client

[![Build Status](https://travis-ci.org/blackbumer/autoscout24_client.png)](https://travis-ci.org/blackbumer/autoscout24_client)

REST api client. It uses 4.1.1 REST API version.
More information about API could be found at
[www.developergarden.com](http://www.developergarden.com/)

This gem is in very early development stage.

## Installation

Add this line to your application's Gemfile:

    gem 'autoscout24'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install autoscout24

## Configure

There are several ways to configure gem.

### via ENVIRONMENT variables:

You may specify API username and password in shell variables:

      AUTOSCOUT24_USERNAME="MyName"
      AUTOSCOUT24_PASSWORD="MyPassword"

### via hash:

     Autoscout24Client.configure
      ({
         username: "your_username",
         password: "your_password",
         culture_id: "ru-RU",
         default_search_params:
             {
                 countries: %w(B CH D F I NL),
                 show_with_images_only: "True",
                 show_private_vehicles: "False"
             }
      })

if you use rails you may place this code into **config/initializers/autoscout24.rb**

### via yaml file:

      Autoscout24Client.configure_with("config/autoscout24.yml")

## Usage

TODO: Write a usage example

## Contributing


1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Road map

If you have an idea please open an issue or use [pivotaltracker](https://www.pivotaltracker.com/projects/722313)


## Trademark note

AutoScout24 is registered trademark owned by AutoScout24 GmbH

