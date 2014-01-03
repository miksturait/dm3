class Work::EnsureEachDayForCoworkerTarget < Struct.new(:coworker_target)
  def process
    clear_unneeded_resources
    create_all_daily_coworker_targets
  end

  private

  delegate :daily_targets, :work_unit_id, :coworker_id, :hours_per_day, :working_days,
           to: :coworker_target

  def create_all_daily_coworker_targets
    working_days.each do |date|
      daily_targets.
          create!(work_unit_id: work_unit_id,
                  coworker_id: coworker_id,
                  day: date,
                  hours: hours_per_day)
    end
  end

  def clear_unneeded_resources
    daily_targets.delete_all
  end
end