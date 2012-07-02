class EvitemsController < InheritedResources::Base

  # nestage
  belongs_to :event
  
  def index
    @event = Event.find(params[:event_id])
    # pour éditer un evitem sans la page edit, s'il est dans les params
    @evitem = begin Evitem.find(params[:evitem_id]) rescue nil end
  end
  
  
  def create

    @evitem = Evitem.new(params[:evitem])
    @evitem.event_id = params[:event_id]
    @evitem.pos = 1
    
    last_pos = 0
    if ( @evitem.event.evitems.count != 0 )
      last_pos = @evitem.event.evitems.order(:pos).last.pos
    end
    
    @evitem.pos = last_pos + 1
  
    if @evitem.save
      redirect_to :back, :notice => 'Invoiced event item created'
    else
      redirect_to :back, :error => 'Error creating invoiced event item'
    end

  end
  
  # nécessaire pour les redirections  
  def update

    @evitem = Evitem.find(params[:id])
    
    if @evitem.update_attributes(params[:evitem])
      redirect_to :back, :notice => 'Invoiced event item created'
    else
      redirect_to :back, :error => 'Error creating invoiced event item'
    end
    
  end

  
  def destroy
    
    #click trop rapides
    sv = begin Evitem.find(params[:id]) rescue nil end
        
    if sv != nil && Evitem.destroy(params[:id])
      redirect_to :back, :notice => "Evitem destroyed."
    else
      redirect_to :back, :error => "Error destroying evitem."
    end    
    
  end

  
   
  def edit
    
    @event = Event.find(params[:event_id])
    @evitem = Evitem.find(params[:id])
    
  end
  
  
  def move_up
   
    item_to_move = Evitem.find(params[:id])
    event_id     = item_to_move.event_id
    first_pos    = item_to_move.event.evitems.order(:pos).first.pos
   
    if first_pos < item_to_move.pos
      item1 = item_to_move
      item2 = Evitem.where("event_id = ? AND pos < ?", event_id, item_to_move.pos).order(:pos).reverse.first       
      item1.pos, item2.pos = item2.pos, item1.pos
        
      if ( item1.save && item2.save )
        redirect_to :back, :notice => 'Evitem moved up.'
      else
        redirect_to :back, :error => 'Error moving evitem up.'
      end
    else
      redirect_to :back, :notice => 'Evitem already up.'
    end
   
  end


  def move_down
   
    item_to_move = Evitem.find(params[:id])
    event_id     = item_to_move.event_id
    last_pos     = item_to_move.event.evitems.order(:pos).last.pos
   
    if last_pos > item_to_move.pos
      item1 = item_to_move
      item2 = Evitem.where("event_id = ? AND pos > ?", event_id, item_to_move.pos).order(:pos).first       
      item1.pos, item2.pos = item2.pos, item1.pos
        
      if ( item1.save && item2.save )
        redirect_to :back, :notice => 'Evitem moved down.'
      else
        redirect_to :back, :error => 'Error moving evitem down.'
      end
    else
      redirect_to :back, :notice => 'Evitem already down.'
    end
     
  end
  
end