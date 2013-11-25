require 'spec_helper'

describe Phase do
  # has_many :invoices // TODO: this will not be part of that app
  pending 'V2 :: relation with other objects'

  it { should_not allow_value(*%w(hrm process_and_tools ccc metreno)).for(:wuid) }
  it { should allow_value(nil).for(:wuid) }
end