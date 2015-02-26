# Mori

### Badgers
[![Code Climate](https://codeclimate.com/github/pineworks/mori.png)](https://codeclimate.com/github/pineworks/mori)
[![Build Status](https://travis-ci.org/pineworks/mori.png?branch=master)](https://travis-ci.org/pineworks/mori)
[![Coverage Status](https://coveralls.io/repos/pineworks/mori/badge.png?branch=master)](https://coveralls.io/r/pineworks/mori?branch=master)

Mori is a lightweight Rails Engine built to handle authentication.

Mori was built with the intention of being easy to override, and easy to implement.

## Installing

Mori is a Rails Engine tested against Rails 3.2+ and Ruby 1.9.3+

Include it in your Gemfile
``` ruby
gem 'mori'
```

Bundle
```
bundle install
```

After your development database exists, run the generator
```
rails g mori:install
```

The generator does the following:
  - Inserts Mori::User in your User model (or creates the User Model)
  - Inserts Mori::Controller in your ApplicationController
  - Creates a migration to add missing collumns, or create a new table.

## Configuration

Mori comes with configuration options. You can override defaults in `config/initializers/mori.rb`

``` ruby
Mori.configure do |config|

  # Mori Default Configuration

  config.from_email = 'reply@example.com'
  config.app_name = Rails.application.class.parent_name.humanize
  config.allow_sign_up = true
  config.dashboard_path = '/'
  config.after_sign_up_path = '/'
  config.after_logout_path = '/'
  config.token_expiration = 14
end

```

Readme Changes

