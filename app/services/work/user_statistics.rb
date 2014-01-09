class Work::UserStatistics < Struct.new(:params)

  def summary
    {
        this_month: this_month,
        this_week: this_week,
        last_month: last_month
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
    workload = CalculateHoursWorked.new(period, coworker)
    {
        hours_worked: "#{workload.hours}:#{workload.minutes}"
    }
  end

  def coworker
    @coworker ||=
        Coworker.where(email: coworker_email).first!
  end

  def coworker_email
    params[:coworker_email]
  end

  class CalculateHoursWorked < Struct.new(:period, :coworker)
    def minutes
      (total_minutes_worked_in_period % 60).to_s.rjust(2,'0')
    end

    def hours
      total_minutes_worked_in_period / 60
    end

    private

    def total_minutes_worked_in_period
      @minutes_worked_in_period ||=
          coworker.time_entries.overlapping_with(period).sum(:duration)
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