class Membership < Sequel::Model
  many_to_one :group
  many_to_one :restaurant      
end        
