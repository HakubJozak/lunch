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
        Lunch::Offer.new($stdout).list
      else
        Lunch::Offer.new($stdout).print_daily_menu(group: cmd)
      end
    end

  end
end
