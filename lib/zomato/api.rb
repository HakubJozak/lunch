require 'httparty'

module Zomato
  class Api
    include HTTParty
    format :json

    base_uri 'https://developers.zomato.com/api/v2.1/'
    default_params :format => 'json'
    # debug_output $stdout

    def restaurant(query)
      json = get('/search', query)
      json['restaurants'].first
    end

    def daily_menu(id)
      json = get('/dailymenu', res_id: id)
      # FFS!
      if m = json['daily_menus']
        m.first['daily_menu']
      end
    end

    def restaurants(query)
      @restaurants ||
        begin
          @restaurants = []
          start = 0

          loop do
            res = get('/search', query.merge(start: start))
            m   = meta(res)

            if m.start >= m.total || (m.start == 0)
              break
            else
              @restaurants << res['restaurants']
              puts start
              puts m
              start = m.start + m.shown
            end
          end

          @restaurants
        end
    end

    def cities
      get '/cities', q: 'Praha'      
    end

    private

    def meta(response)
      OpenStruct.new(
        total: response['results_found'],
        start: response['results_start'],
        shown: response['results_shown'])
    end

    def get(path, query)
      r = self.class.get(path,
                         query:   query,
                         headers: { 'user-key': ENV['ZOMATO_KEY'] })
      json = r.parsed_response
    end
  end
end
