#!/bin/sh
rails db:migrate
rails db:migrate RAILS_ENV=test
