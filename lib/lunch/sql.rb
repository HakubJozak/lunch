module Lunch
  module Sql
    # Create schema unless it exists.
    def self.create_schema?
      # @db.drop_table :restaurants
      # @db.drop_table :groups
      # @db.drop_table :memberships      
      
      DB.create_table? :restaurants do
        primary_key :id
        Integer :id_zomato
        String :name
        String :raw, text: true
        index :id_zomato, unique: true
      end

      DB.create_table? :groups do
        primary_key :id
        String :name
      end

      DB.create_table? :memberships do
        primary_key :id
        Integer :group_id
        Integer :restaurant_id	
      end
    end
  end
end
