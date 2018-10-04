#!/bin/bash -ex

cd /rails_app

tmpreaper 7d /tmp/

mkdir -p tmp/pids/
rm -f tmp/pids/*.pid

bundle check || bundle install --binstubs="$BUNDLE_BIN"
exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf