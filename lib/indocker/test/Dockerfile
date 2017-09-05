FROM ruby:2.3.1
WORKDIR app
RUN touch Gemfile || cat `source "https://rubygems.org"` > Gemfile
CMD bundle install