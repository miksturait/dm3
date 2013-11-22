class User < ActiveRecord::Base
  rolify
  validates_presence_of :name

  has_many :time_entries, class_name: Work::TimeEntry

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
         user.name = auth['info']['name'] || ""
         user.email = auth['info']['email'] || ""
      end
    end
  end

end
