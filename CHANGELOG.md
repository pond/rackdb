## 1.1.0 (2016-07-06)

* Update to Rack 2, requiring Ruby 2.2 or later. Local development ruby version file for RBEnv updated to 2.2.5 and version 2.1 removed from Travis build matrix.

## 1.0.0 (2016-05-04)

* Adds override of `config.yml` via `DATABASE_URL` environment variable; see `README.md` for details.
* RCov added to test suite to verify test coverage of lines of code, albeit not all branch conditions. The coverage report makes it easy to see which things are covered and which things aren't (e.g. because they're imported from another code base with assumed coverage there).
* Now considered feature-complete to original design goals and stable, so bumping to version 1.0.0.

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
