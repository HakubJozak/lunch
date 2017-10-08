module Lunch
  module Sql
    class Restaurant < Sequel::Model
      include Lunch::Lookup

      one_to_many :memberships
      many_to_many :groups, join_table: :memberships

      def to_s
        address = json['location']['address']
        "#{name} (#{address})"
      end      

      def print_daily_menu(out = $stdout)
        out.puts name
        out.puts '---------------------------------------------'

        if menu = zomato.daily_menu(id_zomato)
          menu['dishes'].each_with_index do |dish,i|
            dish = OpenStruct.new(dish['dish'])
            out.puts "#{i+1}) #{dish.name} - #{dish.price}"
          end
        else
          out.puts 'No daily menu found.'
        end
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
