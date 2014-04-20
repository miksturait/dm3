require 'spec_helper'

describe Dm2::FinanceController do
  describe "Invoice Create" do
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
              },
              euro: 16941
          }
      }
    }
    let(:invoice) { Finance::Invoice.last }

    subject(:return_message) { JSON.parse(response.body) }

    it { should eq({
                       "status" => "ok",
                       "invoice" => {
                           "id" => invoice.id
                       }
                   })
    }

    context "invoice fields" do
      subject { invoice }

      its(:dm2_id) { should eq(234) }
      its(:number) { should eq('22/2014') }
      its(:customer_name) { should eq('Statoil') }
      its(:line_items) { should eq({
                                       'Some item one ' => "4598",
                                       'Another item' => "12343"
                                   }) }
      its(:euro) { should eq(16941) }
    end

  end

  describe "Invoice Update" do
    let!(:invoice) { ::Finance::Invoice.create({
                                                        dm2_id: 234,
                                                        number: '22/2014',
                                                        customer_name: 'Statoil',
                                                        line_items: {
                                                            'Some item one ' => 4598,
                                                            'Another item' => 12343
                                                        },
                                                        euro: 16941
                                                    })}
    let(:create_once_again) {
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
              },
              euro: 2000
          }
      }
    }

    it { expect { create_once_again }.to_not change { Finance::Invoice.count } }

    it { expect { create_once_again }.to change { invoice.reload.euro }.from(16941).to(2000) }
  end
end
