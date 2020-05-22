#!/bin/bash -ex
cd /rails_app

mkdir -p tmp/pids/
rm -f tmp/pids/*.pid

exec bundle exec puma -C config/puma.rb
