require 'sequel'


module Lunch
  class SqlStore < Lunch::StoreBase
    # TODO: to be implemented
    def initialize
      create_schema?
    end

    def save!
      true
    end

    def load!
      true
    end

    def groups
      Sql::Group.all
    end

    def restaurants
      Sql::Restaurant.all
    end

    def find_restaurant_by_id(id)
      Sql::Restaurant[id]      
    end

    def default_group
    end

    def create_group(g)
      Sql::Group.find_or_create(name: g.name) do |n|
        n.restaurants.each do |r|
          g.add_restaurant(r)
        end
      end
    end
    
    def create_restaurant(r)
      Sql::Restaurant.find_or_create(id_zomato: r.id) do |n|
        n.name = r.name
        n.raw = r.to_h.to_json
      end
    end

    def find_group(name)
      nil
    end

    alias reload! load!

    private

    # Create schema unless it exists.
    def create_schema?
      # @db.drop_table :restaurants
      # @db.drop_table :groups
      # @db.drop_table :memberships      
      
      @db.create_table? :restaurants do
        primary_key :id
        Integer :id_zomato
        String :name
        String :raw, text: true
      end

      @db.create_table? :groups do
        primary_key :id
        String :name
      end

      @db.create_table? :memberships do
        primary_key :id
        Integer :group_id
        Integer :restaurant_id	
      end

      puts @db[:restaurants].count
    end
  end
end
