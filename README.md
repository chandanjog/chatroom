# chatroom
A simple chat application using websockets. https://sheltered-refuge-5350.herokuapp.com/sessions/new

### System dependencies
  * Ruby version 2.0.0, use a ruby version manager like rvm, rbenv to install ruby.
  * Mongodb
  * Redis primarily used by websocket-rails

### Running locally
  * Checkout the project and cd to the root dir.
  * gem install bundler
  * bundle install
  * Run mongod on default port
  * Run redis-server on default port
  * PORT=3000 bundle exec foreman start
    * runs the web server on port 3000
    * Also runs a scheduled job to cleanup old sessions

### Running tests
  * bundle exec rspec
