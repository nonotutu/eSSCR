class InvoicesController < InheritedResources::Base

  def events
    @invoice = Invoice.find(params[:id])
    @events_without_invoice = Event.where(:invoice_id => nil)
  end

  def overview
    @invoice = Invoice.find(params[:id])
  end
  
end