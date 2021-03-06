module Dm2
  class Support
    include Singleton

    class << self
      def clear
        Dm2::TimeEntry.where(spent_on: nil).delete_all
        Dm2::TimeEntry.where("hours < 0").delete_all
        ::Coworker.delete_all
        ::Work::Unit.delete_all
        ::Work::TimeEntry.delete_all
      end

      def rebuild_work_unit_structure_and_worklog_hours(customer, child)
        project                = create_project_for_customer(customer, child)
        time_entries_to_import = child.time_entries.group(:user_id, :spent_on).count
        puts "\n\n #{project.name} \n => #{time_entries_to_import} - "
        child.time_entries.group(:user_id, :spent_on).sum(:hours).each do |key, workload|
          puts "*"
          dm2_user_id, date = *key
          if (coworker = find_or_create_coworker(dm2_user_id))
            period = calculate_period_base_on_date_and_workload(coworker, date, workload)
            coworker.time_entries.create(work_unit: project.active_phase, period: period)
          end
        end
      end

      def calculate_period_base_on_date_and_workload(coworker, date, workload)
        workload_in_minutes = (workload * 60.0).ceil
        range               = date.to_datetime..date.to_datetime+23.hours+59.minutes+59.seconds
        start_at            = detect_start_at_for_coworker_and_range(coworker, range)
        start_at..start_at+workload_in_minutes.minutes
      end

      def detect_start_at_for_coworker_and_range(coworker, range)
        if (last_time_entry = coworker.time_entries.overlapping_with(range).last)
          last_time_entry.period.end
        else
          range.begin
        end
      end

      def dm2_dm3_coworker_mapping
        @dm2_dm3_coworker_mapping ||= {}
      end

      def find_or_create_coworker(dm2_user_id)
        dm2_dm3_coworker_mapping[dm2_user_id] || build_coworker_based_on_dm2(dm2_user_id)
      end

      def build_coworker_based_on_dm2(dm2_user_id)
        if (dm2_user = Dm2::User.where(id: dm2_user_id).first)
          ::Coworker.create(email: dm2_user.email, name: dm2_user.name).tap { |coworker| dm2_dm3_coworker_mapping[dm2_user_id] = coworker }
        end
      end

      def company_selleo
        @company_selleo ||= Company.create(name: 'Selleo')
      end

      def create_customer_from_root(dm2_project)
        company_selleo.create_children(
            name: dm2_project.name
        )
      end

      def create_project_for_customer(customer, dm2_project)
        wuid = (dm2_project.identifier || dm2_project.name).downcase.scan(/[a-z\_\.0-9]+/).join
        customer.create_children!(
            wuid: wuid,
            name: dm2_project.name
        )
      end
    end
  end
end
