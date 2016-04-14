# `rackdb`

[![Gem Version](https://badge.fury.io/rb/rackdb.svg)](https://rubygems.org/gems/rackdb) [![Build Status](https://travis-ci.org/pond/rackdb.svg?branch=master)](https://travis-ci.org/LoyaltyNZ/rackdb) [![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## About

**rackdb** is a database console for Ruby applications that run on Rack, which follow the Rails-like convention of a `config/database.yml` file describing the database connection parameters. This includes [Rails applications](http://rubyonrails.org) and [Hoodoo services](http://hoodoo.cloud/).

It is based upon [`racksh`](https://github.com/sickill/racksh) and the Ruby on Rails `dbconsole` [code](https://github.com/rails/rails/blob/master/railties/lib/rails/commands/dbconsole.rb). For more information, see the Rails documentation for `dbconsole`.

## Installation

    gem install rackdb

## Usage

To open a default shell:

    cd some_application_or_service
    bundle exec rackdb

For help:

    bundle exec rackdb --help

Quick access to specific environment database consoles:

    bundle exec rackdb <environment_name>

## Bugs & feature requests

Please use the [GitHub issue tracker](https://github.com/pond/rackdb/issues).

## Authors

 * Created by Andrew Hodgkinson - [http://pond.org.uk/](http://pond.org.uk/)
 * Derives from:
   * https://github.com/sickill/racksh
   * https://github.com/rails/rails/blob/master/railties/lib/rails/commands/dbconsole.rb
