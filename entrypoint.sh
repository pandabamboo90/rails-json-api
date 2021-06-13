#!/bin/bash

# -----------------------------------------------------------------
# Variables
# -----------------------------------------------------------------
TAG="[entrypoint.sh] -"

#
# CONTAINER_TYPE values
#
# - SETUP: to run the setup for DB / migration / seed data
# - MIGRATE: to run only rails "db:migrate" script
# - WEB: to run web server
#
CONTAINER_TYPE="WEB"

# -----------------------------------------------------------------
# The scripts
# -----------------------------------------------------------------

echo "== $TAG Running entrypoint.sh script with CONTAINER_TYPE=$CONTAINER_TYPE"

echo "== $TAG Copying config/database.docker.yml ----> config/database.yml =="
cp config/database.docker.yml config/database.yml

echo "== $TAG Clearing tmp/pids to make sure there is no server running =="
rm -rf tmp/pids/*.pid*

if [ "$CONTAINER_TYPE" == "MIGRATE" ]; then
  echo "== $TAG Running rails db:migrate =="
  bundle exec rails db:migrate
elif [ "$CONTAINER_TYPE" == "SETUP" ]; then
  echo "== $TAG Running bin/setup for setting up DB & migration =="
  bin/setup

  echo "== $TAG Seeding data =="
  bundle exec rails db:seed

  echo "== $TAG Staring web server =="
  bundle exec rails s -b 0.0.0.0 -p 3000
else
  echo "== $TAG Staring web server =="
  bundle exec rails s -b 0.0.0.0 -p 3000
fi
