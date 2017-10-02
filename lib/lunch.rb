# coding: utf-8
require_relative "lunch/version"
require_relative "zomato/api"
require_relative "zomato/city"


require 'fileutils'


module Lunch
  class Cli
    def print_menu(restaurant)
      return unless restaurant

      puts restaurant.name
      puts '---------------------------------------------'
      
      if menu = zomato.daily_menu(restaurant.id)
        menu['dishes'].each_with_index do |dish,i|
          dish = OpenStruct.new(dish['dish'])
          puts "#{i+1}) #{dish.name} - #{dish.price}"
        end
      else
        puts 'No daily menu found.'
      end
    end

    def run(argv = ARGV)
      case cmd = argv.first
      when 'update'
        update_restaurants
        save_restaurants
        puts 'Restaurant list updated.'
      else
        [ /Incruenti/, /Akropolis/ ].each do |regexp|
          print_menu find_restaurant(regexp)
          puts "\n\n"
        end
      end
    end

#    def save_vegies
# File.open("data/vegetarian.json",'w') do |f|
#   r = zomato.restaurants(city_id: 84, cuisine_id: 308)
#   f.write(r.to_json)
# end      
#    end

    private

    def find_restaurant(regexp)
      restaurants.find do |r|
        r.name =~ regexp
      end
    end
    
    def restaurants
      @restaurants ||= 
        JSON.parse(File.read(config_file)).map do |json|
          OpenStruct.new(json)
        end
    end

    def zomato
      @zomato ||= Zomato::Api.new
    end

    def update_restaurants
      names = [ 'Incruenti', 'Moment',
                'Plevel', 'Akropolis',
                'Etnosvět', 'Gouranga' ]
      
      @restaurants = names.map do |name|
        zomato.restaurant(city_id: 84, q: name)
      end
    end

    def save_restaurants
      File.open(config_file,'w') do |f|
        f.write(@restaurants.to_json)
      end        
    end

    def config_file
      dir = "#{ENV['HOME']}/.config/lunch"
      config_file = [ dir, 'restaurants.json' ].join('/')
      FileUtils.mkdir_p(dir)
      config_file
    end

  end
end





