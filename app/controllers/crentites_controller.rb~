class VolosController < InheritedResources::Base

  def index
  
    @service = Service.find(params[:service]) 
    @event = Event.find(@service.event_id) 
  
  end
  
end