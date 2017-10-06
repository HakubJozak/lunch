module Lunch
  class Group < OpenStruct
    def to_json(*args)
      {
        name: name,
        restaurant_ids: restaurants.map(&:id)
      }.to_json(*args)
    end

  end
end
