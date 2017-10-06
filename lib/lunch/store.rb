module Lunch
  class Store
    attr_reader :restaurants, :groups

    def initialize
      if File.exist?(data_file)
        reload!
      else
        @restaurants = []
        @groups = []
      end
    end

    def save!
      File.open(data_file,'w') do |f|
        f.write({
          groups: @groups,
          restaurants: @restaurants.uniq.map(&:to_h)
        }.to_json)
      end    
    end

    def reload!
      data = JSON.parse(File.read(data_file))

      @restaurants = data['restaurants'].map { |r|
        Lunch::Restaurant.new(r)
      }
      
      @groups = data['groups'].map { |r|
        Lunch::Group.new(r)
      }

    rescue
      puts 'Failed to load data file.'
      puts $!.message
      @restaurants = []
      @groups = []
    ensure
      puts "#{@restaurants.size} restaurants and #{@groups.size} groups."
    end

    def add_restaurant(restaurant)
      return unless restaurant
      restaurants << restaurant
      save!
    end

    private

    def config_dir
      dir = "#{ENV['HOME']}/.config/lunch"      
      FileUtils.mkdir_p(dir)
      dir
    end

    def data_file
      [ config_dir, 'restaurants.json' ].join('/')
    end


    def config_file
      [ config_dir, 'lunch.yaml' ].join('/')
    end  
  end

end
