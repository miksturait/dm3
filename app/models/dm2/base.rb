module Dm2
  class Base < ActiveRecord::Base
    self.abstract_class = true

    establish_connection ENV['DM2_DATABASE_CONFIG']
  end
end
