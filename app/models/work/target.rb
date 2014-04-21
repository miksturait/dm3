class Work::Target < ActiveRecord::Base
  belongs_to :work_unit, class_name: Work::Unit
  belongs_to :invoice, class_name: Finance::Invoice
  has_many :daily_targets, class_name: Work::DailyCoworkerTarget

  before_validation :inherit_period_from_work_unit
  validates :period, presence: true
  before_save :cache_working_hours
  after_save :create_daily_targets

  delegate :working_hours, :working_days, to: :calculate_working_hours
  delegate :begin, :end, to: :period, prefix: true, allow_nil: true

  scope :within_period, ->(range) { where(["period && daterange(?,?, '[]')", range.begin.to_s, range.end.to_s]) }

  private

  def inherit_period_from_work_unit
    self.period = work_unit.try(:period) if period.blank?
  end

  def create_daily_targets
    Work::EnsureEachDayForCoworkerTarget.new(self).process
  end

  def cache_working_hours
    self.cache_of_total_hours = working_hours
  end

  def calculate_working_hours
    @calculate_working_hours ||=
        Work::CalculateWorkingHours.new(period, coworker, hours_per_day)
  end
end