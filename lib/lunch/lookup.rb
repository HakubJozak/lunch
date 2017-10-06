# coding: utf-8
module Lunch::Lookup
    private

    def find_restaurant(regexp)
      restaurants.compact.find do |r|
        r.name =~ regexp
      end
    end

    def restaurants

    end

    def zomato
      @zomato ||= Zomato::Api.new
    end

    def store
      @store ||= Lunch::Store.new
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

end
