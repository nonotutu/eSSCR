class NositemsController < InvoicesController #InheritedResources::Base

  # nestage
  belongs_to :invoice
  
  def index
    generate_liste
    @invoice = Invoice.find(params[:invoice_id])
    # pour éditer un evitem sans la page edit, s'il est dans les params
    @nositem = begin Nositem.find(params[:nositem_id]) rescue nil end
  end
  
  
  def create

    @nositem = Nositem.new(params[:nositem])
    @nositem.invoice_id = params[:invoice_id]
    @nositem.pos = 1
    
    last_pos = 0
    if ( @nositem.invoice.nositems.count != 0 )
      last_pos = @nositem.invoice.nositems.order(:pos).last.pos
    end
    
    @nositem.pos = last_pos + 1
  
    if @nositem.save
      redirect_to :back, :notice => 'Invoiced nosscr item created'
    else
      redirect_to :back, :error => 'Error creating invoiced nosscr item'
    end

  end
  
  # nécessaire pour les redirections  
  def update

    @nositem = Nositem.find(params[:id])
    
    if @nositem.update_attributes(params[:nositem])
      redirect_to :back, :notice => 'Invoiced nosscr item created'
    else
      redirect_to :back, :error => 'Error creating invoiced nosscr item'
    end
    
  end

  
  def destroy
    
    #click trop rapides
    sv = begin Nositem.find(params[:id]) rescue nil end
        
    if sv != nil && Nositem.destroy(params[:id])
      redirect_to :back, :notice => "Nositem destroyed."
    else
      redirect_to :back, :error => "Error destroying nositem."
    end    
    
  end

  
   
  def edit
    
    @invoice = Invoice.find(params[:invoice_id])
    @nositem = Nositem.find(params[:id])
    
  end
  
  
  def move_up
   
    item_to_move = Nositem.find(params[:id])
    invoice_id     = item_to_move.invoice_id
    first_pos    = item_to_move.invoice.nositems.order(:pos).first.pos
   
    if first_pos < item_to_move.pos
      item1 = item_to_move
      item2 = Nositem.where("invoice_id = ? AND pos < ?", invoice_id, item_to_move.pos).order(:pos).reverse.first       
      item1.pos, item2.pos = item2.pos, item1.pos
        
      if ( item1.save && item2.save )
        redirect_to :back, :notice => 'Nositem moved up.'
      else
        redirect_to :back, :error => 'Error moving nositem up.'
      end
    else
      redirect_to :back, :notice => 'Nositem already up.'
    end
   
  end


  def move_down
   
    item_to_move = Nositem.find(params[:id])
    invoice_id     = item_to_move.invoice_id
    last_pos     = item_to_move.invoice.nositems.order(:pos).last.pos
   
    if last_pos > item_to_move.pos
      item1 = item_to_move
      item2 = Nositem.where("invoice_id = ? AND pos > ?", invoice_id, item_to_move.pos).order(:pos).first       
      item1.pos, item2.pos = item2.pos, item1.pos
        
      if ( item1.save && item2.save )
        redirect_to :back, :notice => 'Nositem moved down.'
      else
        redirect_to :back, :error => 'Error moving nositem down.'
      end
    else
      redirect_to :back, :notice => 'Nositem already down.'
    end
     
  end
  
end