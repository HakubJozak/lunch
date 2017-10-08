module Lunch
  class Store < Lunch::StoreBase
    def initialize
      if File.exist?(data_file)
        reload!
      else
        @restaurants = []
        @groups = []
      end
    end

    def save!
      json = {
          groups: @groups,
          restaurants: @restaurants.uniq.map(&:to_h)
        }.to_json

      File.open(data_file,'w') do |f|
        f.write(json)
      end
    rescue
      puts 'Failed to save data file.'
      puts $!.message
    end

    def load!
      data = JSON.parse(File.read(data_file))

      @restaurants = data['restaurants'].map { |r|
        Lunch::Restaurant.new(r)
      }
      
      @groups = data['groups'].map do |g|
        res = g['restaurant_ids'].map { |id|
          find_restaurant_by_id(id)
        }

        Lunch::Group.new(g.merge(name: g['name'], restaurants: res))
      end
    rescue
      raise if Lunch.env.development?
      puts 'Failed to load data file.'
      puts $!.message
      @restaurants = []
      @groups = []
    ensure
      # puts "#{@restaurants.size} restaurants and #{@groups.size} groups."
    end

    alias :reload! :load!

    def find_restaurant_by_id(id)
      @restaurants.find { |s| s.id == id }
    end

    def default_group
      @groups.first
    end

    def find_group(name)
      @groups.find { |g| g.name == name }
    end

    def create_group(group)
      groups << group
      save!
    end


    def create_restaurant(restaurant)
      return unless restaurant
      restaurants << restaurant
      save!
    end

    private

    def data_file
      [ config_dir, 'restaurants.json' ].join('/')
    end
  end

end
