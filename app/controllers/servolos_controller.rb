class ServolosController < InheritedResources::Base
  
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
  
  
end