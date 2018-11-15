#!/bin/bash -ex
cd /rails_app

mkdir -p tmp/pids/
rm -f tmp/pids/*.pid

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
