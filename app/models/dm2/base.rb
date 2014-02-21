module Dm2
  class Base < ActiveRecord::Base
    config = {
        adapter:  'mysql',
        host:     'localhost',
        database: 'dm2',
        username: 'root',
        password: ''
    }
    self.abstract_class = true
    establish_connection config
  end
end
