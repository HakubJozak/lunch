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

  end
end
