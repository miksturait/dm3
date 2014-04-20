class Finance::Invoice < ActiveRecord::Base
  validates :dm2_id, presence: true, uniqueness: true
  validates :number, presence: true
  validates :customer_name, presence: true


  default_scope -> { order(number: :desc) }

  has_many :targets, class_name: Work::Target

  def name
    "[#{hours_booked}h] :: #{number} :: #{customer_name}"
  end

  def hours_booked
    targets.sum(:cache_of_total_hours)
  end
end
