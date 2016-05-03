## 0.0.4 (2016-05-03)

* Fix very silly error where local machine via `bundle exec` resolved renamed file `init.rb` successfully but, of course, the clean deployment didn't; it was renamed to `console.rb`. Fixed and added a couple of simple additional tests to cover the executed binary and make sure it wakes up OK.
* Refer to top level constants with a `::` prefix so that error messages in the light of missing dependencies are easier to understand.
* Require `rack` within the code so that attempts to use the command outside of `bundle exec` stand a greater chance of working correctly anyway.
* Some code style changes for legibility.

## 0.0.2, 0.0.3 (2016-04-18)

* Regenerate `Gemfile.lock` with Bundler 1.11.2 and perform a maintenance update.
* Ruby 2.1.8 `.ruby_version` file added to source distribution for local development.

## 0.0.1 (2016-04-14)

* Initial release, based upon [`racksh`](https://github.com/sickill/racksh) and the Ruby on Rails `dbconsole` [code](https://github.com/rails/rails/blob/master/railties/lib/rails/commands/dbconsole.rb) (as of Railties v4.2.6).
