class Work::TimeEntry < ActiveRecord::Base
  attr_accessor :exception

  belongs_to :user
  belongs_to :work_unit, class_name: Work::Unit

  before_validation :check_inclusion, :check_for_low_level_exceptions
  before_save :set_duration

  validate :period, presence: true
  validate :work_unit_id, presence: true

  scope :skip_self, ->(time_entry) do
    where(["#{self.table_name}.id != ?", time_entry.id]) unless time_entry.new_record?
  end
  scope :overlapping_with, ->(range) { where(["period && tstzrange(?,?)", range.begin.to_s, range.end.to_s]) }

  def start_at
    period.begin if period
  end

  def end_at
    period.end if period
  end

  def inclusive?
    period &&
        self.class.
            skip_self(self).
            where(user_id: user_id).
            overlapping_with(period).exists?
  end

  private

  def check_inclusion
    errors[:period] << "overlaps already created record" if inclusive?
  end

  def check_for_low_level_exceptions
    exception.each do |attribute, low_level_exceptions|
      low_level_exceptions.each do |low_level_exception|
        errors[attribute] << low_level_exception.message
      end
    end if exception
  end

  def set_duration
    self.duration = calculate_minutes
  end

  delegate :calculate_minutes, to: :time_diff

  def time_diff
    TimeDiff.new(start_at, end_at)
  end

  class TimeDiff < Struct.new(:start_at, :end_at)
    def calculate_minutes
      time_diff[:hour] * 60 +
          time_diff[:minute]
    end

    private

    def time_diff
      @time_diff ||= Time.diff(start_at, end_at)
    end
  end
end