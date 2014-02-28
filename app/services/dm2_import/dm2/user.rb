module Dm2
  class User < Dm2::Base
    def name
      [firstname, lastname].join(' ')
    end
  end
end
