class Dm2::FinanceController < Dm2::ApiController

  def create_invoice
      render json: {
          status: :ok,
          invoice: {
              id: invoice.id
          }
      }
  end

  private

  def invoice
    @invoice ||=
        ::Finance::Invoice.create!(invoice_params)
  end

  def invoice_params
     params.require(:invoice).permit(:dm2_id, :number, :customer_name, :euro).tap do |permited_params|
       permited_params[:line_items] = params[:invoice][:line_items].permit!
     end
  end
end
