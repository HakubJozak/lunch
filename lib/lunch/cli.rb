# coding: utf-8
require 'tty-prompt'


module Lunch
  class Cli
    include Lunch::Lookup

    def run(argv = ARGV)
      store.load!

      case cmd = argv.shift
      when 'update'
        update_restaurants
        save_restaurants
        puts 'Restaurant list updated.'

      when 'group'
        group = Lunch::Prompt.new.new_group(argv.shift)
        store.groups << group
        store.save!

      when 'add'
        r = Lunch::Prompt.new.find_restaurant(argv.shift)
        store.add_restaurant(r)

      when 'list'
        store.groups.each do |g|
          puts g.name
          puts '-----------------'
          g.restaurants.each do |r|
            puts r.name
          end
          puts "\n\n"
        end

      else
        if group = store.find_group(cmd)
          group.restaurants.each(&:print_daily_menu)
          puts "\n\n"
        else
          puts "Unknown group #{name}"
        end
      end
    end

  end
end
