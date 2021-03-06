class RefacsController < EventsController #InheritedResources::Base
  
  belongs_to :event
  

  def index
    generate_liste
    # pour le menu
    @event = Event.find(params[:event_id])
    # TODO : pour éditer un refac sans la page edit, s'il est dans les params ?
    @refacs = Refac.where(:event_id => @event.id).all
    @refac = begin Refac.find(params[:refac_id]) rescue nil end
  end

  
  # nécessaire pour overrider les redirect_to par défaut
  def create

    @refac = Refac.new(params[:refac])
       
    if @refac.save
      redirect_to :back, :notice => "Refac created"
    else
      redirect_to :back, :alert => "Error creating refac"
    end

  end


  # nécessaire pour overrider les redirect_to par défaut
  def destroy
    
    # click trop rapides
    rf = begin Refac.find(params[:id]) rescue nil end
    
    if rf != nil && Refac.destroy(params[:id])
      redirect_to :back, :notice => "Refac destroyed"
    else
      redirect_to :back, :alert => "Error destroying refac"
    end

  end

  # nécessaire car redirections overridées
  def update

    @refac = Refac.find(params[:id])
    
    if @refac.update_attributes(params[:refac])
      redirect_to :back, :notice => 'Refac updated'
    else
      redirect_to :back, :alert => 'Error updating refac'
    end
    
  end

  
  
end