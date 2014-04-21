require 'spec_helper'

describe Finance::HealthCheck, :focus do
  let(:statoil) { Customer.create(name: 'Statoil') }
  let(:dnb) { Customer.create(name: 'DNB') }
  let(:quantus) { Customer.create(name: 'Quantus') }
  let(:vtelligence) { Customer.create(name: 'Vtelligence') }
  let(:simon) { create(:coworker, email: 'simon@mikstura.it') }
  let(:david) { create(:coworker, email: 'david@mikstura.it') }

  before do
    # Statoil
    create(:unit_target, period: "[2014-04-01,{2014-04-30]", work_unit: statoil, hours_per_day: 8,
           invoice: create(:finance_invoice, paid_at: "2014-03-28"))
    create(:unit_target, period: "[2013-09-01,{2013-11-30]", work_unit: statoil, hours_per_day: 8,
           invoice: create(:finance_invoice, paid_at: "2013-09-5"))
    simon.time_entries.create(work_unit: statoil, period: "[2014-04-22 10:00,2014-04-22 17:00]")
    david.time_entries.create(work_unit: statoil, period: "[2014-04-22 10:00,2014-04-22 17:00]")
    simon.time_entries.create(work_unit: statoil, period: "[2013-04-23 10:00,2013-04-23 12:00]")

    # DNB
    create(:unit_target, period: "[2014-04-01,{2014-04-30]", work_unit: dnb, hours_per_day: 8,
           invoice: create(:finance_invoice, paid_at: '2014-03-25'))
    create(:unit_target, period: "[2014-01-01,{2014-02-28]", work_unit: dnb, hours_per_day: 8)
    simon.time_entries.create(work_unit: dnb, period: "[2014-04-24 14:00,2014-04-24 17:00]")
    david.time_entries.create(work_unit: dnb, period: "[2014-04-23 14:00,2014-04-23 17:00]")

    # QANTUS
    simon.time_entries.create(work_unit: quantus, period: "[2014-04-25 9:00,2014-04-25 17:00]")
    david.time_entries.create(work_unit: quantus, period: "[2014-04-24 9:00,2014-04-24 17:00]")
    simon.time_entries.create(work_unit: quantus, period: "[2013-04-26 10:00,2013-04-26 15:00]")

    # Vtelligence
    create(:unit_target, period: "[2013-01-01,{2013-02-28]", work_unit: vtelligence, hours_per_day: 8)
    simon.time_entries.create(work_unit: vtelligence, period: "[2013-04-27 10:00,2013-04-27 15:00]")
  end

  let(:healthcheck) { described_class.new(2014) }

  it { expect(healthcheck.customers).to match_array([dnb, quantus, statoil]) }

  it { expect(healthcheck.data_hash).
      to eq([
                {
                    client: 'Statoil',
                    diff: 176-14, paid: 176-14, booked: 176-14, status: 5,
                    last_time_worked_at: Date.parse("2014-04-22")},
                {
                    client: 'DNB',
                    diff: 176+344-6, paid: 176-6, booked: 176+344-6, status: 5,
                    last_time_worked_at: Date.parse("2014-04-24")},
                {
                    client: 'Quantus',
                    diff: -16, paid: 0, booked: 0, status: 1,
                    last_time_worked_at: Date.parse("2014-04-25")
                }
            ]
         ) }

  # Ususally at the end of year, or if we need correct something
  describe "Settlement" do
    xit "allow to tweak values"
  end
end