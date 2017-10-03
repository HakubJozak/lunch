# coding: utf-8
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
      when /sinfin|snfn|office|kancl|dlouha/
        print_daily_menus /Maitrea/, /La Casa Blů/ 
      else
        print_daily_menus /Incruenti/, /Akropolis/ 
      end
    end

#    def save_vegies
# File.open("data/vegetarian.json",'w') do |f|
#   r = zomato.restaurants(city_id: 84, cuisine_id: 308)
#   f.write(r.to_json)
# end
#    end

    private

    def print_daily_menus(*restaurants)
      restaurants.each do |regexp|
          print_menu find_restaurant(regexp)
          puts "\n\n"
        end      
    end

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
                'Etnosvět', 'Gouranga',
                'La Casa Blů',
                'Maitrea', 'V Kolkovně' ]

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
