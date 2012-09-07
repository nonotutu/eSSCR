class ServolosController < InheritedResources::Base

  #before_filter :heures_auto, :only => [:create]
  
  # l'ordre a une importance, car double-nesté
  belongs_to :event, :service

  def index
    @event = Event.find(params[:event_id])
    @service = Service.find(params[:service_id])
    # pour éditer un evitem sans la page edit, s'il est dans les params
    @servolo = begin Servolo.find(params[:servolo_id]) rescue nil end
  end

  
  # nécessaire pour overrider les redirect_to par défaut
  def create

    @servolo = Servolo.new(params[:servolo])

    if @servolo.save
      redirect_to :back, :notice => "Servolo created (Volunteer added to service)"
    else
      redirect_to :back, :error => "Error creating servolo"
    end

  end
  
  
  # nécessaire pour overrider les redirect_to par défaut
  def destroy
    
    # click trop rapides
    sv = begin Servolo.find(params[:id]) rescue nil end
    
    if sv != nil && Servolo.destroy(params[:id])
      redirect_to :back, :notice => "Servolo destroyed (Volunteer removed from service)"
    else
      redirect_to :back, :error => "Error destroying servolo"
    end

  end

  # nécessaire car redirections overridées
  def update

    @servolo = Servolo.find(params[:id])
    
    if @servolo.update_attributes(params[:servolo])
      redirect_to :back, :notice => 'Servolo updated'
    else
      redirect_to :back, :error => 'Error updating servolo'
    end
    
  end
  
  def heures_auto
  
#   if heures_auto // TODO : rajouter dans le servolos/form // TODO : tester
    @servolo = Servolo.new(params[:servolo])
    
    @servolo.starts_at = @servolo.service.debut
    @servolo.ends_at = @servolo.service.ends_at
    if @servolo.service.debut == @servolo.service.depart_at
      @servolo.rendezvous = "1"
    else
      @servolo.rendezvous = "2"
    end

  end

end