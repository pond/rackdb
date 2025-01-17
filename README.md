# `rackdb`

**ARCHIVED** - this gem was long ago superceded by `bundle exec rails dbconsole`.

## About

**rackdb** is a database console for Ruby applications that run on Rack, which follow the Rails-like convention of a `config/database.yml` file describing the database connection parameters. This includes [Rails applications](http://rubyonrails.org) and [Hoodoo services](http://hoodoo.cloud/).

If environment variable `DATABASE_URL` is defined, it will be assumed to contain a fully qualified URI for connecting to the database of choice and will take precedence over `config.yml`. This is often the case for Hoodoo services in cloud-based deployment configurations with remote database services like RDS, rather than under development or in production with a locally hosted database.

* The URI is parsed and `config.yml`-style parameters are filled in using its components.
* PostgreSQL, MySQL and SQL Server URIs are very similar and should all work in theory, conveying the host, port, username, password and database name options where present in the URI. Only PostgreSQL is actually tested against a real database at the time of writing - the others were coded by observation.
* SQLite URIs of `sqlite://` are assumed to be for a SQLite v3 database and the pathname of the URI is taken as the path to the database file on the local filesystem.
* Oracle URIs are extremely unusual and are not supported.
* A `jdbc:` scheme prefix is ignored if present; for example, `jdbc:mysql://...` and `mysql://` would both be treated the same way.

The code is based upon [`racksh`](https://github.com/sickill/racksh), the Ruby on Rails `dbconsole` [code](https://github.com/rails/rails/blob/master/railties/lib/rails/commands/dbconsole.rb) and the Hoodoo [service shell](https://github.com/LoyaltyNZ/service_shell). For more information, see the Rails documentation for `dbconsole`.

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
