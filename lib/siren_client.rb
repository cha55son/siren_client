dir = 'siren_client'
require "#{dir}/version"

# Dependencies
require 'yaml'
require 'httparty'
require 'active_support/inflector'

# SirenClient files
require "#{dir}/exceptions"
require "#{dir}/http"
require "#{dir}/link"
require "#{dir}/field"
require "#{dir}/action"
require "#{dir}/entity"
require "#{dir}/base"
