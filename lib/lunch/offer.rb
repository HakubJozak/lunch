module Lunch
  class Offer
    include Lunch::Lookup

    # def initialize
    #   @out = StringIO.new
    # end
    # def to_s
    #   @out.string
    # end

    def print_daily_menus(*restaurants)
      @out = StringIO.new

      restaurants.each do |regexp|
        print_menu find_restaurant(regexp)
        @out.puts "\n\n"
      end

      yield @out.string if block_given?
    end

    def print_menu(restaurant)
      return unless restaurant

      @out.puts restaurant.name
      @out.puts '---------------------------------------------'

      if menu = zomato.daily_menu(restaurant.id)
        menu['dishes'].each_with_index do |dish,i|
          dish = OpenStruct.new(dish['dish'])
          @out.puts "#{i+1}) #{dish.name} - #{dish.price}"
        end
      else
        @out.puts 'No daily menu found.'
      end
    end

  end
end
