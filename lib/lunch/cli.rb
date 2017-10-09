# coding: utf-8
require 'tty-prompt'


module Lunch
  class Cli
    include Lunch::Lookup

    def run(argv = ARGV.dup)
      store.load!

      case cmd = argv.shift
      when 'update'
        update_restaurants
        save_restaurants
        puts 'Restaurant list updated.'

      when 'group'
        group = Lunch::Prompt.new.new_group(argv.shift)
        print_info

      when 'add'
        name = argv.shift

        if take_first?(argv.shift)
          r = zomato.search(name).first
        else
          r = Lunch::Prompt.new.find_restaurant(name)
        end

        store.create_restaurant(r)
        print_info
      when 'purge'
        Lunch::Sql.drop_schema
        Lunch::Sql.create_schema
        
      when 'list'
        Lunch::Offer.new($stdout).list
      else
        Lunch::Offer.new($stdout).print_daily_menu(group: cmd)
      end


    end

    private

    def print_info
      r = Lunch::Sql::Restaurant.count
      g = Lunch::Sql::Group.count
      puts "#{r} restaurants & #{g} groups."
    end
    
    def take_first?(str)
      str =~ /-t|--take-first/
    end

  end
end
