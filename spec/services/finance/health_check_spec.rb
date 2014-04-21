require 'spec_helper'

describe Finance::HealthCheck, :focus do

  # status:
  #   => 0  below -24 (bumping red)
  #   => 1  below 0 (red)
  #   => 2  below 16 (bumping orange)
  #   => 3  below 40 (orange)
  #   => 4  below 80 (light green)
  #   => 5  more then 80 (green)
  # [
  #   { diff: -34, paid: 0, booked: 0, client: 'Metreno', status: [0..5], last_time_worked_at: 'yesterday' },
  #   { ... },
  #   ...
  # ]

  xit "service object that calculate / sort data / quantify situaion"
end