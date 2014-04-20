require 'spec_helper'

describe Dm2::ApiController do

  context "Finance Information", :focus do
    # [
    #   { diff: -34, client: 'Metreno', status: [0..10] },
    #   { ... },
    #   ...
    # ]

    xit "api for finance dashboard"

    xit "service object that calculate / sort data / quantify situaion"


    # round boubles with diff number / small name of client and color
    xit "dashboard with info about hours diff (worked vs bought) in dm2"
  end

  context "Bonus :-) :: Allow to create Target Together with creating Invoice", :focus do
    xit "extend the push api"

    xit "create service object that handle this use case (creating muliple objects"

    xit "display all targets withing the invoice (show / edit)"

    xit "add interface in dm2 that will allow create one target per invoice update / create"
  end

  context "Bonus :: Bonus :: Visualize Targets", :focus do
    # http://visjs.org/examples/timeline/02_dataset.html
    # or
    # Google Calendar Integration
    # One Calendar per co-worker / one per client
    xit "rething strategy how"

    # * just one calender "Schedule" where all the objects are read only
    #   and within details we would be inviting certain people to add it to their own calendar
    xit "if google calender - rething how it should works"
  end

  pending "work units fetching"
end
