class Work::CalculateWorkingHours < Struct.new(:period, :coworker, :hours_per_day)
  def hours
    business_days * working_hours_for_business_day
  end

  def business_days
    @business_days ||=
        count_business_days
  end

  def working_hours_for_business_day
    hours_per_day || Work::CalculateWorkingHours.default_working_hours
  end

  def self.default_working_hours
    8
  end

  private

  def count_business_days
    period.count do |day|
      days_off_info.business_day?(day)
    end
  end

  def days_off_info
    @days_off_info ||=
        DaysOffInfo.new(period, coworker)
  end

  class DaysOffInfo < Struct.new(:period, :coworker)
    def business_day?(day)
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
      []
      # TODO :-)
      # Work::DaysOffPeriod.official_days_off_and_days_of_for_coworker(coworker).in_period(period).select(:period).all
    end
  end
end