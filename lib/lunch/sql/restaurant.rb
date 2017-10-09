module Lunch
  module Sql
    class Restaurant < Sequel::Model
      include Lunch::Lookup

      one_to_many :memberships
      many_to_many :groups, join_table: :memberships

      def to_s
        address = json['location']&.public_send(:[],'address')
        "#{name} (#{address})"
      end      

      def print_daily_menu(out = $stdout)
        out.puts name
        out.puts '---------------------------------------------'

        if menu = zomato.daily_menu(id_zomato)
          dishes(menu)
          out.puts "#{dish.name} - #{dish.price}"
        else
          out.puts 'No daily menu found.'
        end
      end

      private

      def dishes(menu)
        menu['dishes'].map do |dish|
          OpenStruct.new(dish['dish'])
        end        
      end

      def json
        @json ||= JSON.parse(raw)
      end
    end
  end
end
