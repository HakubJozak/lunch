# coding: utf-8
require 'slack-ruby-bot'
require_relative '../lunch'


module Lunch
  class Waiter < SlackRubyBot::Bot

    command 'ping' do |client, data, match|
      client.say(text: 'pong', channel: data.channel)
    end

    match /^(lunch|obed)\?$/ do |client, data, match|
      menu = Lunch::Offer.new.print_daily_menu(group: )
      client.say(text: "\n#{menu}", channel: data.channel)        
    end
  end
end
