module Lunch
  class Restaurant < OpenStruct
    def ==(other)
      other.id == self.id
    end

    def to_s
      address = location['address']
      "#{name} (#{address})"
    end
  end
end
