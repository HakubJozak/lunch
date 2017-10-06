module Lunch
  class Restaurant < OpenStruct
    include Lunch::Lookup

    def ==(other)
      other.id == self.id
    end

    def to_s
      address = location['address']
      "#{name} (#{address})"
    end

    def print_daily_menu(out = $stdout)
      out.puts name
      out.puts '---------------------------------------------'

      if menu = zomato.daily_menu(id)
        menu['dishes'].each_with_index do |dish,i|
          dish = OpenStruct.new(dish['dish'])
          out.puts "#{i+1}) #{dish.name} - #{dish.price}"
        end
      else
        out.puts 'No daily menu found.'
      end
    end
    
  end
end
