# coding: utf-8
require 'tty-prompt'


module Lunch
  class Cli
    include Lunch::Lookup

    def run(argv = ARGV)
      store.load!

      case cmd = argv.shift
      when 'update'
        update_restaurants
        save_restaurants
        puts 'Restaurant list updated.'

      when 'group'
        group = Lunch::Prompt.new.new_group(argv.shift)
        store.groups << group
        store.save!

      when 'add'
        r = Lunch::Prompt.new.find_restaurant(argv.shift)
        store.add_restaurant(r)

      when 'list'
        store.groups.each do |g|
          puts g.name
          puts '-----------------'
          g.restaurants.each do |r|
            puts r.name
          end
          puts "\n\n"
        end

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

    def create_group(name = nil)
      prompt = Lunch::Prompt.new
      restaurants = make_group
    end

    def add_restaurant(name = nil)

    end

    
#    def save_vegies
# File.open("data/vegetarian.json",'w') do |f|
#   r = zomato.restaurants(city_id: 84, cuisine_id: 308)
#   f.write(r.to_json)
# end
#    end


  end
end
