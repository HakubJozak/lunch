# coding: utf-8
require_relative "zomato/api"
require_relative "zomato/city"

require_relative "lunch/version"
require_relative "lunch/lookup"
require_relative "lunch/restaurant"
require_relative "lunch/group"
require_relative "lunch/cli"
require_relative "lunch/offer"
require_relative "lunch/store_base"
require_relative "lunch/store"
require_relative "lunch/sql_store"
require_relative "lunch/prompt"


require 'fileutils'


module Lunch
  class Environment < OpenStruct
    def development?
      name == :development
    end
  end
  
  def self.env
    Lunch::Environment.new(name: :development)
  end
end
