require 'spec_helper'

describe Dm2::FinanceController do
  describe "Invoice Create", :focus do
    let!(:call) {
      # get because something is f* with combination ruby 1.8.x / rails 2.x / some gems
      #     -> resulting that post isn't working at all
      # line item value is in Euro always
      get 'create_invoice', {
          auth_token: '9552211f1ac89d0bb10863a71a92',
          invoice: {
              dm2_id: 234,
              number: '22/2014',
              customer_name: 'Statoil',
              line_items: {
                  'Some item one ' => 4598,
                  'Another item' => 12343
              }
          }
      }
    }
    let(:invoice) { Finance::Invoice.last }

    subject(:return_message) { JSON.parse(response.body) }

    it { should eq({
                       "status" => "OK",
                       "id" => invoice.id
                   })
    }

    context "invoice fields" do
      subject { invoice }

      its(:dm2_id) { should eq('234') }
      its(:number) { should eq('22/2014') }
      its(:customer_name) { should eq('Statoil') }
      its(:line_items) { should eq({
                                       'Some item one ' => 4598,
                                       'Another item' => 12343
                                   }) }
    end
  end

  context "create new end point for invoices", :focus do
    # Finance::Invoice Object
    # * DM2 Invoice Id
    # * Customer Name
    # * Line Items { 'title' => 'value'}

    xit "allow to create invoice object, return id object"

    # Add Fields to Invoice
    # * dm3_id
    # * pushed_at
    # Logic should be in service object
    xit "push notifications from dm2 (after invoice save)"

    xit "deploy & test"

    # * HABTM Work::Target
    xit "allow to link target with invoice"
  end
end
