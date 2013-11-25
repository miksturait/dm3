require 'spec_helper'

describe Company do

  it { should_not allow_value(*%w(hrm process_and_tools ccc metreno)).for(:wuid) }
  it { should allow_value(nil).for(:wuid) }
end