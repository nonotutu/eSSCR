class ServicesController < InheritedResources::Base

  # nestage
  belongs_to :event
  
  
  def destroy
    
    @service = Service.find(params[:id])
    
    if @service.destroy
      redirect_to event_path(@service.event.id), :notice => 'Service destroyed'
    else
      mess = 'Error destroying service'
      unless @service.errors.empty?
        mess += " : " + @service.errors.messages[:base].join(", ")
      end
      redirect_to :back, :notice => mess
    end
    
  end
  
  def update

    datizer
    
     @service = Service.find(params[:id])
  
       if @service.update_attributes(params[:service])
         redirect_to event_service_path, :notice => "Service updated"
       else
         redirect_to :back, :alert => "Error updating service" + @service.errors.messages.to_s
       end
    
  end
  
  def create

    datizer
    
    @service = Service.new(params[:service])
    @service.event_id = params[:event_id]
    
    depart_at   = datizer_2(@service.starts_at, @service.depart_at)
    surplace_at = datizer_2(@service.starts_at, @service.surplace_at)
    
    if depart_at
      @service.depart_at = depart_at
    end
      
    if surplace_at
      @service.surplace_at = surplace_at
    end
    
    if @service.save
      redirect_to event_service_path(@service.event, @service), :notice => 'Service created'
    else
	    redirect_to :back, :alert => 'Error creating service' + @service.errors.messages.to_s
    end
 
  end

  def overview
    # nécessaires pour les menus
    @service = Service.find(params[:id])
    @event = @service.event
  end


private
  
  def datizer
    
    params[:service]['depart_at(1i)'] = ""
    params[:service]['depart_at(2i)'] = ""
    params[:service]['depart_at(3i)'] = ""
    params[:service]['surplace_at(1i)'] = ""
    params[:service]['surplace_at(2i)'] = ""
    params[:service]['surplace_at(3i)'] = ""
 
    starts_at = DateTime.new(params[:service]['starts_at(1i)'].to_i,
                             params[:service]['starts_at(2i)'].to_i,
                             params[:service]['starts_at(3i)'].to_i,
                             params[:service]['starts_at(4i)'].to_i,
                             params[:service]['starts_at(5i)'].to_i)
    unless ( params[:service]['depart_at(4i)'].blank? || params[:service]['depart_at(5i)'].blank? )
      depart_at = DateTime.new(params[:service]['starts_at(1i)'].to_i,
                              params[:service]['starts_at(2i)'].to_i,
                              params[:service]['starts_at(3i)'].to_i,
                              params[:service]['depart_at(4i)'].to_i,
                              params[:service]['depart_at(5i)'].to_i)
      depart_at   = datizer_2(starts_at, depart_at)
    end
    if ( !params[:service]['surplace_at(4i)'].blank? && !params[:service]['surplace_at(5i)'].blank? )
      surplace_at = DateTime.new(params[:service]['starts_at(1i)'].to_i,
                                params[:service]['starts_at(2i)'].to_i,
                                params[:service]['starts_at(3i)'].to_i,
                                params[:service]['surplace_at(4i)'].to_i,
                                params[:service]['surplace_at(5i)'].to_i)
      surplace_at = datizer_2(starts_at, surplace_at)
    end
    
    if depart_at
      params[:service]['depart_at(1i)'] = depart_at.year.to_s
      params[:service]['depart_at(2i)'] = depart_at.month.to_s
      params[:service]['depart_at(3i)'] = depart_at.day.to_s
      params[:service]['depart_at(4i)'] = depart_at.hour.to_s
      params[:service]['depart_at(5i)'] = depart_at.minute.to_s
    end
   
    if surplace_at
      params[:service]['surplace_at(1i)'] = surplace_at.year.to_s
      params[:service]['surplace_at(2i)'] = surplace_at.month.to_s
      params[:service]['surplace_at(3i)'] = surplace_at.day.to_s
      params[:service]['surplace_at(4i)'] = surplace_at.hour.to_s
      params[:service]['surplace_at(5i)'] = surplace_at.minute.to_s   
    end
    
  end

  # assigne le YYYYMMDD de 'start' à 'depart'
  # retire un jour à 'depart' s'il est après 'start'
  def datizer_2(start, depart)
    
    if start
      if depart
        dt = DateTime.new( start.year, start.month, start.day,
                           depart.hour, depart.min )
        depart = dt
        if depart > start
          depart -= 1.day
        end
      end
    end

    depart
    
  end

  
end