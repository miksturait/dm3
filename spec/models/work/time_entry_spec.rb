require 'spec_helper'

describe Work::TimeEntry do

  # * validate range inclusion - best in postgresql
  #   EFFORT_TYPE_REGEX =  /(regular|overtime|weekend|on-site)/i
  pending "validation"

  # * belongs to Work::Uni
  # * belongs to User
  pending "relation with other objects"
end