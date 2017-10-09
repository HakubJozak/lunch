# coding: utf-8
require 'slack-ruby-bot'
require_relative '../lunch'


module Lunch
  class Waiter < SlackRubyBot::Bot

    class Action
    end
    
    def initialize
      @conversations = {}
    end
    
    command 'ping' do |client, data, match|
      client.say(text: 'pong', channel: data.channel)
    end

    match /\d+/ do |client, data, match|
      user   = client.users[data.user]
      
      if action  = user.delete(:lunch_action)
        action.call(match.to_s.to_i)
      end
    end
    
    match /^add\s+(\w+)/ do |client, data, match|
      zomato = Zomato::Api.new
      store  = Lunch::SqlStore.new
      user   = client.users[data.user]
      channel = client.ims.values.find { |ch| ch.user == data.user }['id']
      query   = match[1]
      
      restaurants = zomato.search(query).map do |r|
        store.create_restaurant(r)
      end

      user[:lunch_action] = -> (i) {
        if r = restaurants[i-1]
          client.say text: "You picked #{r.name}", channel: channel
        end
      }

      response = restaurants.map.with_index {|r,i| "#{i+1} - #{r.to_s}" }
      client.say(text: 'Which one?', channel: channel)
      client.say(text: response.join("\n"), channel: channel)
    end

    match /^(lunch|obed)\?$/ do |client, data, match|
      out = StringIO.new
      Lunch::Offer.new(out).print_daily_menu(group: nil)
      client.say(text: "\n#{out.string}", channel: data.channel)        
    end
  end
end
