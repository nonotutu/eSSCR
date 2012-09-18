class InvoicesController < InheritedResources::Base

  def show
    @invoice = Invoice.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        pdf = InvoicePdf.new(@invoice)
        send_data pdf.render, filename: "invoice_#{@invoice.created_at.strftime("%d/%m/%Y")}.pdf", type: "application/pdf"
      end
    end
  end

  
  def events
    @invoice = Invoice.find(params[:id])
    @events_without_invoice = Event.where(:invoice_id => nil).where(:is_free => false)
  end

  def overview
    @invoice = Invoice.find(params[:id])
  end
  
  def new
    @invoice = Invoice.new
    @invoice.number = begin Invoice.order(:number).last.number.next rescue "2010-001" end
  end

end