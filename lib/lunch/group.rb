module Lunch
  class Group < OpenStruct
    def initialize(attrs)
      super(attrs)
      @store = store
    end

    private :store

    def restaurants
      @restaurant.rb
    end
  end
end
