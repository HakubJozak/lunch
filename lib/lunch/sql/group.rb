class Group < Sequel::Model
  one_to_many :memberships
  many_to_many :restaurants, join_table: :memberships
end
