class VolosController < InheritedResources::Base

  def index
  
    #@service = Service.find(params[:service_id]) 
    @event = Event.find(@service.event_id)
  
  end
  
end