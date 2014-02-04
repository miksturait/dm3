require 'spec_helper'

describe Work::UserStatistics do

  pending 'refactor last month summary'

  # lazy loading - don't calculate as long as you don't need
  {
      this_week: {
          # per coworker / period
          personal: {
              total_worked: 'method',
              total_target: 'method',
              project_object: {
                  worked: 'value_in_minutes',
                  target: 'value_in_hours'}
          },
          # team is defined by personal
          # per project / period
          team: {
              project_object: {
                  total_worked: 'method', # should take into account hours for current user also
                  total_target: 'method',
                  coworker_object: {
                      worked: 'value_in_minutes',
                      target: 'value_in_hours'
                  }
              }
          }
      }
  }


  # final json should be :
  #{
  #    personal: {
  #        this_week: {
  #            total: {
  #                worked: 735,
  #                target: 2400,
  #            },
  #            project_name: {
  #                worked: 735,
  #                target: 1800
  #            },
  #            another_name: {
  #                worked: 0,
  #                target: 600
  #            },
  #        },
  #        this_month: {
  #
  #        }
  #    },
  #    team: {
  #        this_week: {
  #            project_name: {
  #                total: {
  #                    worked: 9600,
  #                    target: 45
  #                },
  #                coworker_email: {
  #                    worked: 735,
  #                    target: 1800
  #                },
  #                another_email: {
  #                    worked: 225,
  #                    target: 600
  #                }
  #            },
  #            another_name: {
  #
  #            }
  #        },
  #        this_month: {
  #
  #        }
  #    }
  #}

  pending "private class Pending, should be extracted to main namespace"
end