require "rubygems"
require "bundler/setup"
require "sinatra"
require "haml"
require "json"
require "tinder"
require "rest_client"
require "i18n"
require "active_support"
require "./scrumptious"
require "./lib/inflectionist"

set :run, false
set :raise_errors, true

run Scrumptious.new