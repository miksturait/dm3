class Work::UserStatistics < Struct.new(:params)
  def summary
    {
        personal: personal_stats_as_hash,
        team: team_stats_as_hash
    }
  end

  private

  def personal_stats_as_hash
    personal_stats.each_with_object({}) do |(name, stats), cache|
      cache[name] = stats.to_hash
    end
  end

  def personal_stats
    @personal_stats ||=
        period_helper.all.each_with_object({}) do |(name, period), cache|
          cache[name] = PersonalStats.new(period, coworker)
        end
  end

  def team_stats_as_hash
    period_helper.all.each_with_object({}) do |(name, period), cache|
      cache[name] = TeamStats.new(period, personal_stats[name].projects).to_hash
    end
  end

  class PersonalStats < Struct.new(:period, :coworker)
    def to_hash
      {
          total: {
              worked: worked_hours.total,
              target: target_hours.total,
              available: available_hours.working_hours
          }
      }.merge(all_projects_to_hash)
    end

    private

    def all_projects_to_hash
      all_projects.each_with_object({}) do |project, cache|
        cache[project.name] = {
            worked: worked_hours[project],
            target: target_hours[project]
        }
      end
    end

    delegate :projects, to: :worked_hours

    def all_projects
      (worked_hours.projects + target_hours.projects).uniq.sort_by(&:name)
    end

    def worked_hours
      @worked_hours ||=
          HoursWorkedGroupByProject.new(period, coworker)
    end

    def target_hours
      @target_hours ||=
          HoursTargetGroupByProject.new(period, coworker)
    end

    def available_hours
      @available_hours ||=
          Work::CalculateWorkingHours.new(period, coworker)
    end
  end

  #  project_object: {
  #    total_worked: 'method', # should take into account hours for current user also
  #    total_target: 'method',
  #    coworker_object: {
  #        worked: 'value_in_minutes',
  #        target: 'value_in_hours'
  #    }
  # }
  class TeamStats < Struct.new(:period, :projects)
    def to_hash
      {}
    end
  end

  class HoursWorkedGroupByProject < Struct.new(:period, :coworker)
    def total
      per_project_stats.values.sum
    end

    def [](project)
      per_project_stats[project] || 0
    end

    def projects
      @projects ||=
          per_project_stats.keys
    end

    private

    def per_project_stats
      @per_project_stats ||=
          time_per_project
    end

    def time_per_project
      time_per_work_unit.each_with_object(Hash.new { |h, k| h[k] = 0 }) do |(work_unit_id, duration), cache|
        find_project_based_on_descendant_id(work_unit_id).tap do |project|
          begin
            cache[project] += duration
          rescue => e
            binding.pry
          end
        end
      end
    end

    def time_per_work_unit
      coworker.time_entries.within_period(period).group(:work_unit_id).sum(:duration)
    end

    def find_project_based_on_descendant_id(work_unit_id)
      Project.where("id IN (#{Work::Unit.where(id: work_unit_id).
          select("UNNEST(REGEXP_SPLIT_TO_ARRAY(ancestry, '/')::integer[]) as id").to_sql}) OR id = #{work_unit_id}").
          first
    end
  end

  class HoursTargetGroupByProject < HoursWorkedGroupByProject
    private

    def time_per_work_unit
      coworker.daily_targets.within_period(period).group(:work_unit_id).sum(:hours)
    end
  end

  # for project per coworker
  # fairleads_ids = Project.where(name: 'FairLeads').first.descendant_ids
  # Work::TimeEntry.within_period(period).where(work_unit_id: fairleads_ids).group(:coworker_id).sum(:duration)

  class AllHoursWorkedGroupByProject < Work::UserStatistics::HoursWorkedGroupByProject
    def self.this_year
      period = Date.new(2014,1,1)..Date.new(2014,1,26)
      report(period)
    end

    def self.last_week
      period = Date.new(2014,1,13)..Date.new(2014,1,19)
      report(period)
    end

    def self.report(period)
      new(period, nil).tap do |ahw|
        ahw.projects.each do |p|
          puts("#{p.name} => #{ahw[p]/60}")
        end
      end
    end

    private

    def time_per_work_unit
      Work::TimeEntry.within_period(period).group(:work_unit_id).sum(:duration)
    end
  end

  def coworker
    @coworker ||=
        Coworker.where(email: coworker_email).first!
  end

  def coworker_email
    params[:coworker_email]
  end

  def period_helper
    @period_helper ||= Period.new(Date.today)
  end

  class Period < Struct.new(:today)
    def all
      {
          this_week: this_week,
          this_month: this_month,
          last_month: last_month
      }
    end

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
      date.beginning_of_month..date.end_of_month.end_of_day
    end

    def week(date)
      date.beginning_of_week..date.end_of_week.end_of_day
    end

    def last_day_of_previous_month
      today.beginning_of_month - 1.day
    end
  end
end