module Lunch
  module Sql
    class Restaurant < Sequel::Model
      one_to_many :memberships
      many_to_many :groups, join_table: :memberships

      def to_s
        address = json['location']['address']
        "#{name} (#{address})"
      end      

      private
      
      def json
        @json ||= JSON.parse(raw)
      end
    end

    class Group < Sequel::Model
      one_to_many :memberships
      many_to_many :restaurants, join_table: :memberships

      
    end

    class Membership < Sequel::Model
      many_to_one :group
      many_to_one :restaurant      
    end        
  end
end
