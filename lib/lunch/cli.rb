# coding: utf-8
module Lunch
  class Cli
    include Lunch::Lookup

    def run(argv = ARGV)
      case cmd = argv.first
      when 'update'
        update_restaurants
        save_restaurants
        puts 'Restaurant list updated.'
      when /sinfin|snfn|office|kancl|dlouha/
        Lunch::Offer.new.print_daily_menus(/Maitrea/, /La Casa Blů/) do |menu|
          puts menu
        end
      else
        Lunch::Offer.new.print_daily_menus(/Incruenti/, /Akropolis/) do |menu|
          puts menu
        end
      end
    end

#    def save_vegies
# File.open("data/vegetarian.json",'w') do |f|
#   r = zomato.restaurants(city_id: 84, cuisine_id: 308)
#   f.write(r.to_json)
# end
#    end


  end
end
