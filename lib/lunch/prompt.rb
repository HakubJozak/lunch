module Lunch
  class Prompt < TTY::Prompt
    include Lunch::Lookup

    def find_restaurant(name)
      name ||= ask('Restaurant name?')

      selected = select("Which one?") do |menu|
        zomato.search(name).each do |attrs|
          rest = store.create_restaurant(attrs)
          menu.choice rest.to_s, rest
        end
        
        menu.choice '- Cancel -', nil
      end
    end

    def new_group(name)
      name ||= ask('Group name:')

      picked = multi_select("Which restaurants?", per_page: 10) do |m|
        store.restaurants.each do |r|
          m.choice r.to_s, r
        end
      end

      store.create_group(name: name, restaurants: picked)
    end
  end
end
