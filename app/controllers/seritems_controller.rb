class SeritemsController < EventsController #InheritedResources::Base

  # nestage
  belongs_to :event, :service
  
  def index
    generate_liste
    @event = Event.find(params[:event_id])
    @service = Service.find(params[:service_id])
    # pour éditer un evitem sans la page edit, s'il est dans les params
    @seritem = begin Seritem.find(params[:seritem_id]) rescue nil end
  end
  
  
  def create

    @seritem = Seritem.new(params[:seritem])
    @seritem.service_id = params[:service_id]
    @seritem.pos = 1
        
    last_pos = 0
    if ( @seritem.service.seritems.count != 0 )
      last_pos = @seritem.service.seritems.order(:pos).last.pos
    end
    
    @seritem.pos = last_pos + 1
    
    if @seritem.save
      redirect_to :back, :notice => 'Invoiced service item created'
    else
      redirect_to :back, :error => 'Error creating invoiced service item'
    end
  
  end
    
  
  def update

    @seritem = Seritem.find(params[:id])
    
    if @seritem.update_attributes(params[:seritem])
      redirect_to :back, :notice => 'Invoiced service item created'
    else
      redirect_to :back, :error => 'Error creating invoiced service item'
    end
    
  end
  
  
  def destroy
    
    #click trop rapides
    sv = begin Seritem.find(params[:id]) rescue nil end
    
    if sv != nil && Seritem.destroy(params[:id])
      redirect_to :back, :notice => "Seritem removed from service."
    else
      redirect_to :back, :error => "Error removing seritem from service."
    end    
    
  end
  
  
#   def edit
#     
#     @event = Event.find(params[:event_id])
#     @service = Service.find(params[:service_id])    
#     @seritem = Seritem.find(params[:id])
#     
#   end
  
  
  def move_up
   
    item_to_move = Seritem.find(params[:id])
    service_id   = item_to_move.service_id
    first_pos    = item_to_move.service.seritems.order(:pos).first.pos
   
    if first_pos < item_to_move.pos
      item1 = item_to_move
      item2 = Seritem.where("service_id = ? AND pos < ?", service_id, item_to_move.pos).order(:pos).reverse.first       
      item1.pos, item2.pos = item2.pos, item1.pos
        
      if ( item1.save && item2.save )
        redirect_to :back, :notice => 'Seritem moved up.'
      else
        redirect_to :back, :error => 'Error moving seritem up.'
      end
    else
      redirect_to :back, :notice => 'Seritem already up.'
    end
   
  end


  def move_down
   
    item_to_move = Seritem.find(params[:id])
    service_id   = item_to_move.service_id
    last_pos     = item_to_move.service.seritems.order(:pos).last.pos
   
    if last_pos > item_to_move.pos
      item1 = item_to_move
      item2 = Seritem.where("service_id = ? AND pos > ?", service_id, item_to_move.pos).order(:pos).first       
      item1.pos, item2.pos = item2.pos, item1.pos
        
      if ( item1.save && item2.save )
        redirect_to :back, :notice => 'Seritem moved down.'
      else
        redirect_to :back, :error => 'Error moving seritem down.'
      end
    else
      redirect_to :back, :notice => 'Seritem already down.'
    end
     
  end
   
end