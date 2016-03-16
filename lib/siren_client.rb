dir = 'siren_client'
require "#{dir}/version"

# Dependencies
require 'json'
require 'logger'
require 'httparty'
require 'active_support/inflector'
require 'active_support/core_ext/hash'

# SirenClient files
require "#{dir}/exceptions"
require "#{dir}/raw_response"
require "#{dir}/modules/with_raw_response"
require "#{dir}/link"
require "#{dir}/field"
require "#{dir}/action"
require "#{dir}/entity"
require "#{dir}/base"
