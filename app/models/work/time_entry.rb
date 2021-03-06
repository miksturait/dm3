class Work::TimeEntry < ActiveRecord::Base
  attr_accessor :exception

  belongs_to :coworker
  belongs_to :work_unit, class_name: Work::Unit

  before_validation :check_inclusion, :check_for_low_level_exceptions
  before_save :set_duration

  validate :period, presence: true
  validate :work_unit_id, presence: true

  scope :without_time_entry, ->(time_entry) do
    where(["#{self.table_name}.id != ?", time_entry.id]) unless time_entry.new_record?
  end
  scope :overlapping_with, ->(range) { where(["period && tstzrange(?,?, '()')", range.begin.to_s, range.end.to_s]) }
  scope :within_period, ->(range) { where(["period && tstzrange(?,?, '[]')", range.begin.to_s, range.end.to_s]) }
  scope :work_unit_id_eq, ->(work_unit_id) { where(work_unit_id: Work::Unit.find(work_unit_id).subtree) }
  scope :after_start_time, ->(start_time) { where("period <@ tstzrange(?, 'Infinity', '[]')", start_time.to_s) }
  scope :before_start_time, ->(start_time) { where("lower(period) <@ tstzrange('-Infinity', ?, '[]')", start_time.to_s) }

  def work_unit_id_eq(work_unit_id)
    throw 'aaa'
  end

  def inclusive?
    period &&
        self.class.
            without_time_entry(self).
            where(coworker_id: coworker_id).
            overlapping_with(period).exists?
  end

  delegate :begin, :end,
           to: :period,
           prefix: true, allow_nil: true
  delegate :name, to: :coworker, prefix: true, allow_nil: true

  def label
    work_unit_ancestors_without_client_customer.map(&:label).join(" > ")
  end

  def start_time
    period.begin
  end

  def end_time
    period.end
  end

  private

  def work_unit_ancestors_without_client_customer
    work_unit.ancestors.from_depth(2) << work_unit
  end

  def check_inclusion
    errors[:period] << "overlaps already created record" if inclusive?
  end

  def check_for_low_level_exceptions
    copy_exception_errors if exception
  end

  def copy_exception_errors
    exception.each do |attribute, low_level_exceptions|
      low_level_exceptions.each do |low_level_exception|
        errors[attribute] << if low_level_exception.respond_to?(:message)
                               low_level_exception.message
                             else
                               low_level_exception
                             end
      end
    end
  end

  def set_duration
    self.duration = calculate_minutes
  end

  delegate :calculate_minutes, to: :time_diff

  def time_diff
    TimeDiff.new(period_begin, period_end)
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
