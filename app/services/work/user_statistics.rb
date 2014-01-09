class Work::UserStatistics < Struct.new(:params)

  def summary
    {
        last_month: last_month,
        this_month: this_month,
        this_week: this_week
    }
  end


  private

  def this_month
    hours_worked_in_period(period.this_month)
  end

  def this_week
    hours_worked_in_period(period.this_week)
  end

  def last_month
    hours_worked_in_period(period.last_month)
  end


  def hours_worked_in_period(period)
    DecorateMinutes.decorate(
        {
            hours_worked: base_scope(period).sum(:duration)
        }.merge(per_project_hours_worked_in_period(period))
    )
  end

  def per_project_hours_worked_in_period(period)
    Hash[regroup_by_project(base_scope(period).group(:work_unit_id).sum(:duration)).sort]
  end

  def regroup_by_project(hours_worked_per_work_unit)
    hours_worked_per_work_unit.
        each_with_object(Hash.new { |h, k| h[k] = 0 }) do |key_value, cache|
      work_unit_id, calculate_hours_worked = *key_value
      project_name = Project.where("id IN (#{Work::Unit.where(id: work_unit_id).
          select("UNNEST(REGEXP_SPLIT_TO_ARRAY(ancestry, '/')::integer[]) as id").to_sql})").
          pluck(:name).first
      cache[project_name] += calculate_hours_worked
    end
  end

  def coworker
    @coworker ||=
        Coworker.where(email: coworker_email).first!
  end

  def coworker_email
    params[:coworker_email]
  end

  def base_scope(period)
    coworker.time_entries.overlapping_with(period)
  end

  class DecorateMinutes
    def self.decorate(hash)
      hash.each_with_object({}) do |key_value, cache|
        id, minutes = *key_value
        TimeFormatter.new(minutes).tap do |presenter|
          cache[id] = "#{presenter.hours}:#{presenter.minutes}"
        end
      end
    end

    private

    class TimeFormatter < Struct.new(:time)
      def minutes
        (time % 60).to_s.rjust(2, '0')
      end

      def hours
        time / 60
      end
    end
  end

  def period
    @period ||= Period.new(Date.today)
  end

  class Period < Struct.new(:today)
    def this_month
      month(today)
    end

    def this_week
      week(today)
    end

    def last_month
      month(last_day_of_previous_month)
    end

    private

    def month(date)
      date.beginning_of_month..date.end_of_month
    end

    def week(date)
      date.beginning_of_week..date.end_of_week
    end

    def last_day_of_previous_month
      today.beginning_of_month - 1.day
    end
  end
end