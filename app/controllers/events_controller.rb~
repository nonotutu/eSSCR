class EventsController < InheritedResources::Base

  
  def show
    @event = Event.find(params[:id])
  end
  
  
  def destroy
    
    @event = Event.find(params[:id])
    
    if @event.destroy
      redirect_to events_path, :notice => "Event destroyed"
    else
      mess = 'Error destroying event'
      unless @event.errors.empty?
	mess += " : " + @event.errors.messages[:base].join(", ")
      end
      redirect_to :back, :notice => mess
    end
    
  end
  

  def create

    @event = Event.new(params[:event])
  
    if @event.save
      redirect_to event_path(@event), :notice => 'Event created'
    else
      redirect_to :back, :error => 'Error creating event'
    end
 
  end


  def overview
    @event = Event.find(params[:id])
  end

  
  def fullitem
    @event = Event.find(params[:id])
  end


  def add_to_invoice
    event = Event.find(params[:id])
    invoice = Invoice.find(params[:invoice])
    invoice.events = invoice.events + [event]
    if invoice.save
      redirect_to :back, :notice => 'Event added to invoice'
    else
      redirect_to :back, :error => 'Error adding event to invoice'
    end
  end


  def remove_from_invoice
    event = Event.find(params[:id])
    invoice = event.invoice
    invoice.events = invoice.events - [event]
    if invoice.save
      redirect_to :back, :notice => 'Event removed from invoice'
    else
      redirect_to :back, :error => 'Error removing event from invoice'
    end
  end


end