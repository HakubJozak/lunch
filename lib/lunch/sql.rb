module Lunch
  module Sql
    # Create schema unless it exists.
    def self.drop_schema
      DB.drop_table :restaurants
      DB.drop_table :groups
      DB.drop_table :memberships      
    end

    def self.create_schema
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
        Integer :group_id
        Integer :restaurant_id
        index [ :group_id, :restaurant_id ], unique: true
      end
    end
  end
end
