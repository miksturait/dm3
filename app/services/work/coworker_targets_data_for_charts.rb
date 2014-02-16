class Work::CoworkerTargetsDataForCharts

  def self.all
    Work::CoworkerTarget.all.collect do |coworker_target|
      TargetInfo.new(coworker_target).info
    end.join(",\n")
  end

  class TargetInfo < Struct.new(:coworker_target)

    def info
      %Q{["#{coworker_label}", "#{project_name}", #{start_at}, #{end_at}]}
    end

    delegate :email, to: :coworker
    delegate :period, :cache_of_total_hours, :coworker, to: :coworker_target

    private

    def start_at
      convert_date_to_js(period.begin)
    end

    def end_at
      convert_date_to_js(period.end)
    end

    def convert_date_to_js(date)
      "new Date(#{date.year},#{date.month - 1},#{date.day - 1})"
    end

    def coworker_label
      email + " [#{cache_of_total_hours}]"
    end

    def project_name
      project(coworker_target.work_unit_id).pluck(:name).first
    end

    def project(work_unit_id)
      Project.related_to_descendant_id(work_unit_id)
    end
  end
end
