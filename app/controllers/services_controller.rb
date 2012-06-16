class ServicesController < InheritedResources::Base

  # nestage
  belongs_to :event

  
  #def index
  #  @events_list = Event.all
  #  @event = Event.find(params[:event_id])
  #end
  
  def destroy
    
    @service = Service.find(params[:id])
    # next_service = Service.find(params[:id]).next # TODO : trouver next
    
    if @service.destroy
      redirect_to event_services_path, :notice => 'Service destroyed'
    else
      mess = 'Error destroying service'
      unless @service.errors.empty?
	mess += " : " + @service.errors.messages[:base].join(", ")
      end
      redirect_to :back, :notice => mess
    end
    
  end
  
  
  def create

    @service = Service.new(params[:service])
    @service.event_id = params[:event_id]
	
    if @service.save
      redirect_to event_service_path(@service.event, @service), :notice => 'Service created'
    else
	    redirect_to :back, :error => 'Error creating service'
    end
 
  end

 
  def volos
    @all_active_volos = Volo.all
    @service = Service.find(params[:service_id])
    @event = @service.event
    @servolos = Servolo.where(:service_id => @service.id)
    # nécessaire pour le formulaire d'ajout/édition
    @servolo = begin Servolo.find(params[:servolo_id]) rescue nil end
  end


  def dispositifs
    # nécessaire pour les menus
    @service = Service.find(params[:service_id])
    @event = @service.event
    # nécessaire pour la liste
    @disposers = Disposer.where(:service_id => @service.id)
    # nécessaire pour le formulaire d'ajout/édition
    @disposer = begin Disposer.find(params[:disposer_id]) rescue nil end
  end


end