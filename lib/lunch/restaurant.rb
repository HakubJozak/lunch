module Lunch
  class Restaurant < OpenStruct
    def ==(other)
      other.id == self.id
    end
  end
end

