class Work::TimeEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :work_unit, class_name: 'Work::Unit'

  before_validation :check_inclusion
  before_save :update_duration

  validate :period, presence: true

  def inclusive?
    period && self.class.where(user_id: user_id).where(["period && tstzrange(?,?)", period.begin.to_s, period.end.to_s]).exists?
  end

  private

  def check_inclusion
    errors[:period] << "overlaps already created record" if inclusive?
  end

  def update_duration
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