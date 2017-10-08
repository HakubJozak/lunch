module Lunch
  class StoreBase
    private


    def config_file
      [ config_dir, 'lunch.yaml' ].join('/')
    end      
  end
end
