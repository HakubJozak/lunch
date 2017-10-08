module Lunch
  class StoreBase
    private

    def config_dir
      dir = "#{ENV['HOME']}/.config/lunch"      
      FileUtils.mkdir_p(dir)
      dir
    end

    def config_file
      [ config_dir, 'lunch.yaml' ].join('/')
    end      
  end
end
