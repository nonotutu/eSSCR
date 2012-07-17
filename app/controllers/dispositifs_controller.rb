class DispositifsController < InheritedResources::Base

#   def index
#   
#     @service = Service.find(params[:service]) 
#     @event = Event.find(@service.event_id) 
#   
#   end
  
  def code_image_s1
      code_image(1)
  end
  def code_image_s2
      code_image(2)
  end
  def code_image_s4
      code_image(4)
  end
    
  def code_image(icon_size)
    @image_data = Dispositif.find_by_id(params[:id])
    case icon_size
      when 2
        @image = @image_data.image_s2_binary_data
        send_data @image, :type => @image_data.image_s2_content_type, :disposition => "inline"
      when 4
        @image = @image_data.image_s4_binary_data
        send_data @image, :type => @image_data.image_s4_content_type, :disposition => "inline"
      else
        @image = @image_data.image_s1_binary_data
        send_data @image, :type => @image_data.image_s1_content_type, :disposition => "inline"
    end
  end
    
  def update

#     @service = Service.find(params[:service])
#     @event = Event.find(@service.event_id) 

    @dispositif = Dispositif.find(params[:id])
  
      if @dispositif.update_attributes(params[:dispositif])
        redirect_to dispositif_path, :notice => "Dispositif updated"
      else
        redirect_to :back, :alert => "Error updating dispositif" + @dispositif.errors.messages.to_s
      end
    
  end


end
