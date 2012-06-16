module ApplicationHelper

  
  def to_euro(number)
    number_to_currency(number, :separator => ',', :delimiter => ' ', :unit => "&euro;", :format => "%n %u", :negative_format => "- %n %u")
  end

  
  def to_percent(number)
    number_to_currency(number, :separator => ',', :delimiter => ' ', :unit => "%", :format => "%n %u", :negative_format => "- %n %u") # TODO : faire mieux
  end

  
  def event_calcul_prix_services(event_id)

    event = Event.find(event_id)

    total, montant = BigDecimal.new("0")
    event.services.each do |service|
      sstot = BigDecimal.new("0")
      service.seritems.order('pos').each do |item|
        if item.kind == 1
          montant = item.price * item.qty
        elsif item.kind == 2
          montant = sstot * item.price / 100.0
        end
        sstot += montant
      end
      total += sstot
    end
    
    total
    
  end
  
    
  def event_calcul_prix_total(event_id)

    total = event_calcul_prix_services(event_id)

    event = Event.find(event_id)
    
    event.evitems.order('pos').each do |item|
      if item.kind == 1
        montant = item.price * item.qty
      elsif item.kind == 2
        montant = total * ( item.price / 100.0 )
      end
      total += montant
    end

    total
    
  end 

  
  def table_event_evitems(event_id)

    table = Array.new
    ligne = Array.new
  
    event = Event.find(event_id)

    total_services = event_calcul_prix_services(event_id)
    
    ligne << nil << "Services related items (" + event.services.count.to_s + ")" << nil << nil << to_euro(total_services)
    table << ligne
    ligne = Array.new
      
    total = total_services
    event.evitems.order('pos').each do |item|
      ligne << item.id
      ligne << item.name
      if item.kind == 1
        montant = item.price * item.qty
        ligne << item.qty
        ligne << to_euro(item.price)
      elsif item.kind == 2
        montant = total * item.price / 100.0
        ligne << nil
        ligne << to_percent(item.price)
      end
      ligne << to_euro(montant)
      table << ligne
      ligne = Array.new
      total += montant
    end
    ligne << nil
    ligne << "Total"
    ligne << nil << nil
    ligne << to_euro(total)
    table << ligne
    
    table
    
  end  

  
  def table_event_fullitem(event_id)
    
    table = Array.new
    ligne = Array.new
  
    event = Event.find(event_id)
      
    total = BigDecimal("0")
    
    event.services.order('starts_at').each do |service|
      sstot = BigDecimal("0")
      ligne = Array.new
      ligne << '-4' << ( service.starts_at.to_s(:cust_short) + " - " + service.relative_ends_at ) << nil << nil << nil
      service.seritems.order('pos').each do |item|
        table << ligne
        ligne = Array.new
        ligne << item.id
        ligne << item.name
        if item.kind == 1
          montant = item.price * item.qty
          ligne << item.qty
          ligne << to_euro(item.price)
        elsif item.kind == 2
          montant = sstot * item.price / 100.0
          ligne << nil
          ligne << to_percent(item.price)
        end
        ligne << to_euro(montant)
        table << ligne
        sstot += montant
      end
      total += sstot
      ligne = Array.new
      ligne << -1 << 'Sous-total' << nil << nil << to_euro(sstot)
      table << ligne
    end
    ligne = Array.new
    ligne << -2 << 'Sous-total services' << nil << nil << to_euro(total)
    table << ligne
    

    event.evitems.order('pos').each do |item|
      ligne = Array.new
      ligne << item.id
      ligne << item.name
      if item.kind == 1
        montant = item.price * item.qty
        ligne << item.qty
        ligne << to_euro(item.price)
      elsif item.kind == 2
        montant = total * item.price / 100.0
        ligne << nil
        ligne << to_percent(item.price)
      end
      ligne << to_euro(montant)
      table << ligne
      total += montant
    end
    ligne = Array.new
    ligne << -3 << "Total" << nil << nil << to_euro(total)
    table << ligne
    
    table
  
  end
  
  
  def table_service_seritems(service_id)

    table = Array.new
    ligne = Array.new
  
    service = Service.find(service_id)
      
    total = BigDecimal("0")
    service.seritems.order('pos').each do |item|
      ligne << item.id
      ligne << item.name
      if item.kind == 1
        montant = item.price * item.qty
        ligne << item.qty
        ligne << to_euro(item.price)
      elsif item.kind == 2
        montant = total * item.price / 100.0
        ligne << nil
        ligne << to_percent(item.price)
      end
      ligne << to_euro(montant)
      table << ligne
      ligne = Array.new
      total += montant
    end
    
    oldtot = total
    service.event.evitems.order('pos').each do |item|
      if item.kind == 1
        montant = item.price * item.qty
      elsif item.kind == 2
        montant = total * item.price / 100.0
      end
      total += montant
    end

    ligne << nil << "Event related items" << nil << nil << to_euro(total-oldtot)
    table << ligne
    ligne = Array.new
    
    ligne << nil << "Total" << nil << nil << to_euro(total)
    table << ligne
    
    table
  
  end
  
  
  def table_invoiced_items(tableau)
    
    # id > 0 / name / qte / price / total
    # id < 0 / text / nil / nil   / total
    
    str = "caca"
    
    str
        
  end
  
  
end