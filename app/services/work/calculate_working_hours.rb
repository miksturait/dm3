class Work::CalculateWorkingHours < Struct.new(:period, :coworker, :hours_per_day)

  def working_hours
    working_days.size * working_hours_for_working_day
  end


  def working_days
    @working_days ||=
        select_working_days
  end

  private

  def working_hours_for_working_day
    hours_per_day || Work::CalculateWorkingHours.default_working_hours
  end

  def self.default_working_hours
    8
  end

  def select_working_days
    period.select do |day|
      days_off_info.working_day?(day)
    end
  end

  def days_off_info
    @days_off_info ||=
        DaysOffInfo.new(period, coworker)
  end

  class DaysOffInfo < Struct.new(:period, :coworker)
    def working_day?(day)
      !(is_a_weekend?(day) or
          is_a_day_off?(day))
    end

    def self.week_day_weekends
      [0, 6]
    end

    private

    def is_a_weekend?(day)
      DaysOffInfo.week_day_weekends.include?(day.wday)
    end

    def is_a_day_off?(day)
      list_of_days_off.include?(day)
    end


    def list_of_days_off
      @list_of_days_off ||=
          extract_days_off
    end

    def extract_days_off
      work_days_off_periods.collect do |days_off_period|
        days_off_period.period.to_a
      end.flatten.uniq
    end

    def work_days_off_periods
      work_days_off_period_query_chain.within_period(period).select(:period)
    end

    def work_days_off_period_query_chain
      if coworker
        Work::DaysOffPeriod.official_days_off_and_days_of_for_coworker(coworker)
      else
        Work::DaysOffPeriod.official_days_off
      end
    end
  end
end