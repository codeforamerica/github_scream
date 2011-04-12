require 'bundler'
Bundler.require

#require File.expand_path("../pizza",__FILE__)

require './scream.rb'
run Sinatra::Application

