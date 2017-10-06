require 'sequel'


module Lunch
  class Store
    def initialize(directory)
      @file = "#{directory}/lunch.db"

      unless File.exist?(@file)
        create_schema
      end
    end
  end

  def restaurants

    
  end

  private

  def create_schema
    class Restaurant < Sequel::Model
    end
  end

  def db
    @db ||= Sequel.connect("sqlite://#{file}")    
  end
end
