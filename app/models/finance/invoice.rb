class Finance::Invoice < ActiveRecord::Base
  validates :dm2_id, presence: true, uniqueness: true
  validates :number, presence: true
  validates :customer_name, presence: true
end
