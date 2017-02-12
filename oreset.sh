#!/bin/sh
rm ./db/development.sqlite3
rm ./db/test.sqlite3
rails db:migrate
rails db:migrate RAILS_ENV=test
