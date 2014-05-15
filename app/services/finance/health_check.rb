class Finance::HealthCheck < Struct.new(:year)
  def customers
    customers_data.keys
  end

  def data_hash
    customers_data.collect do |customer, data|
      CustomerHash.new(customer, data).to_hash unless data_is_stale(data)
    end.compact
  end


  private

  def data_is_stale(data)
    -16 < data.hours_diff && data.hours_diff < 0 && data.last_time_worked_at < validity_period
  end

  def validity_period
    30.days.ago
  end

  def period
    period_begin..period_end
  end

  def period_begin
    Date.parse("#{year}-01-01")
  end

  def period_end
    period_begin.end_of_year
  end

  def customers_data
    @customers_data ||=
        ActiveCustomers.all(period)
  end

  class CustomerHash < Struct.new(:customer, :data)
    def to_hash
      {
          client: client_name,
          diff: hours_diff,
          paid: hours_paid,
          booked: hours_booked,
          status: health_status,
          last_time_worked_at: last_time_worked_at
      }
    end

    private

    delegate :hours_booked, :hours_paid, :hours_diff, :last_time_worked_at, to: :data

    def client_name
      customer.name
    end

    def health_status
      HealthStatus.new(hours_diff).status
    end
  end

  # status:
  #   => 0  below -24 (bumping red)
  #   => 1  below 0 (red)
  #   => 2  below 16 (bumping orange)
  #   => 3  below 40 (orange)
  #   => 4  below 80 (light green)
  #   => 5  more then 80 (green)
  class HealthStatus < Struct.new(:diff)
    def status
      if diff > 80
        5
      elsif diff > 40
        4
      elsif diff > 16
        3
      elsif diff > 0
        2
      elsif diff > -24
        1
      else
        0
      end
    end
  end

  class CustomerData < Struct.new(:hours_worked, :targets, :last_time_worked_at)
    def hours_diff
      calculated_hours_booked - hours_worked
    end

    def hours_booked
      if calculated_hours_booked > hours_worked
        calculated_hours_booked - hours_worked
      else
        0
      end
    end

    def calculated_hours_booked
      @calculated_hours_booked ||=
          targets.sum(:cache_of_total_hours)
    end

    def hours_paid
      if calculated_hours_paid > hours_worked
        calculated_hours_paid - hours_worked
      else
        0
      end
    end

    def calculated_hours_paid
      @calculated_hours_paid ||=
          targets.joins(:invoice).where("finance_invoices.paid_at IS NOT NULL").sum(:cache_of_total_hours)
    end
  end

  class ActiveCustomers
    def self.all(period)
      ::Customer.skip_internall.all.each_with_object({}) do |customer, memo|
        FetchData.new(customer, period).tap do |customer_data|
          memo[customer] =
              CustomerData.new(customer_data.hours_worked,
                               customer_data.targets,
                               customer_data.last_time_worked_at) if customer_data.active?
        end
      end
    end

    private

    class FetchData < Struct.new(:customer, :period)
      def active?
        hours_worked > 0 or !targets.empty?
      end

      def last_time_worked_at
        customer.time_entries.within_period(period).order(period: :asc).pluck(:period).last.begin.to_date
      end

      def hours_worked
        @hours_worked ||=
            customer.time_entries.within_period(period).sum(:duration) / 60
      end

      def targets
        @targets ||=
            customer.customer_targets.within_period(period)
      end
    end
  end
end