require 'sequel'


module Lunch
  class SqlStore < Lunch::StoreBase
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
      Sql::Group.all
    end

    def create_group(name:, restaurants:)
      group = Sql::Group.find_or_create(name: name)

      restaurants.each do |r|
        group.add_restaurant(r)
      end      
    end
    
    def create_restaurant(r)
      Sql::Restaurant.find_or_create(id_zomato: r['id']) do |n|
        n.name = r['name']
        n.raw = r.to_json
      end
    end

    def find_group(name)
      Sql::Group.where(name: name).first
    end

    alias reload! load!
  end
end
