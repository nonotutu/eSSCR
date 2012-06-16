class DisposersController < InheritedResources::Base
  
  # nécessaire pour overrider les redirect_to par défaut
  def create
  
    @disposer = Disposer.new(params[:disposer])
    
    if @disposer.quantity <= 0 || @disposer.quantity == nil
      @disposer.quantity = 1
    end
        
    if @disposer.save
      redirect_to :back, :notice => "Disposer created (Dispositif added to service)"
    else
      redirect_to :back, :alert => "Error creating disposer"
    end

  end
  
  
  # nécessaire pour overrider les redirect_to par défaut
  def destroy
    
    # nécessaire click trop rapides
    ds = begin Disposer.find(params[:id]) rescue nil end
    
    if ds != nil && Disposer.destroy(params[:id])
      redirect_to :back, :notice => "Disposer destroyed (Dispositif removed from service)"
    else
      redirect_to :back, :error => "Error destroying disposer"
    end

  end

  # nécessaire car redirections overridées
  def update

    @disposer = Disposer.find(params[:id])
    
    if @disposer.update_attributes(params[:disposer])
      redirect_to :back, :notice => 'Disposer updated'
    else
      redirect_to :back, :error => 'Error updating disposer'
    end
    
  end
  
  
end