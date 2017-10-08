# coding: utf-8
require_relative "zomato/api"
require_relative "zomato/city"

require_relative "lunch/version"
require_relative "lunch/lookup"
require_relative "lunch/cli"
require_relative "lunch/offer"
require_relative "lunch/store_base"
require_relative "lunch/store"
require_relative "lunch/sql_store"
require_relative "lunch/prompt"
require 'fileutils'


module Lunch
  module Config
    def data_file
      [ config_dir, 'lunch.db' ].join('/')
    end

    def config_dir
      dir = "#{ENV['HOME']}/.config/lunch"
      FileUtils.mkdir_p(dir)
      dir
    end
  end

  class Environment < OpenStruct
    def development?
      name == :development
    end
  end
  
  def self.env
    Lunch::Environment.new(name: :development)
  end
end

include Lunch::Config

# FFS! ------------------------
# The model classes have to be defined
# after a DB connection is established.
#

DB = Sequel.connect("sqlite://#{data_file}")
require_relative "lunch/sql/restaurant"
require_relative "lunch/sql/group"
require_relative "lunch/sql/membership"
# -----------------------------

