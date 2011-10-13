require "rubygems"
require "bundler/setup"
require "sinatra"
require "haml"
require "httparty"
require "json"
require "tinder"
require "./scrumptious"

set :run, false
set :raise_errors, true

run Sinatra::Application