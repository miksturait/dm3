require 'spec_helper'

describe Project do
  # has_many :invoices // TODO: this will not be part of that app
  pending 'V2 :: relation with other objects'

  pending 'active phase, require some further improvements'

  it { should validate_presence_of(:wuid) }
  it { should allow_value(*%w(hrm process_and_tools ccc metreno mikstura.it)).for(:wuid)}
  it { should_not allow_value(*%w(hrm-manage a-a - -a a-)).for(:wuid)}
end