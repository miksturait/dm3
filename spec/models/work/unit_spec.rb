require 'spec_helper'

describe Work::Unit do

  # * should have uid and aliases
  # * uniqueness of wuid
  #   => customer within company
  #   => project within customer
  #   => phase have no wuid
  #   => all children within phase
  # * wuid can't have '-' as the value
  pending "validation"

end