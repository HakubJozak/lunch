module Lunch
  class Offer
    include Lunch::Lookup

    def initialize(out = nil)
      @out = out || StringIO.new
    end
    
    def list
      store.groups.each do |g|
        puts g.name
        puts '-----------------'
        g.restaurants.each do |r|
          puts r.name
        end
        puts "\n\n"
      end
    end

    def print_daily_menu(group:)
      group = store.find_group(group) || store.default_group
      
      if group
        group.restaurants.each { |r|
          r.print_daily_menu(@out)
          puts "\n"
        }
      else
        puts 'No group found.'
      end
    end

    private

    def puts(*args)
      @out.puts(*args)
    end
  end
end
