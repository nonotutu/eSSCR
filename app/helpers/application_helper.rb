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
  
  
# retourne : 0 string :  espace du début à la première heure
#            1 boolean : espace de la dernière heure à la fin ?
#            2 integer : nombre d'heures
#            3 string :  espace entre 2 heures
#            4 string :  espace de la dernière heure à la fin
#            5 boolean : espace du début à la première heure ?
  
  def fct_calcul_tableau_heures(debut_service, fin_service)

    duree_service = fin_service - debut_service
    
    # si durée négative, retourne nil
    if ( duree_service <= 0 )
      nil
    end

    # TODO : améliorer
    # tableau de toutes les heures
    tableau = Array.new
    i = debut_service
    while i <= fin_service do
      if i%3600 == 0
        tableau << i - debut_service
      end
      i += 5.minutes
    end

    nombre_heures = tableau.count

    tableau_heures = Array.new
    tableau_heures << ( tableau.first.to_f / duree_service * 100 ).to_s + "%"
    tableau_heures << ( tableau.last == duree_service ? false : true )
    tableau_heures << tableau.count
    tableau_heures << ( 3600.to_f / duree_service * 100 ).to_s + "%"
    tableau_heures << ( (duree_service - tableau.last.to_f) / duree_service * 100 ).to_s + "%"
    tableau_heures << ( tableau.first == 0 ? false : true )
    
    return tableau_heures

  end
  

  def fct_calcul_tableau_servolos(service_id)
    
    service = Service.find(service_id)
    duree_service = ( service.ends_at - service.starts_at ).to_i
    
    graphe = Array.new
    
    service.servolos.each do |servolo|
      ligne = Array.new
      ligne << servolo.volo.first_name
      debut_servolo = ( servolo.starts_at - service.starts_at ).to_i
      if debut_servolo < 0
        ligne << 0
      else
        ligne << debut_servolo
      end
      fin_servolo = ( servolo.ends_at - service.starts_at ).to_i
      if fin_servolo > duree_service
        ligne << duree_service
      else
        ligne << fin_servolo
      end
      graphe << ligne
    end

    graphe.each do |ligne|
      ligne[1] = ligne[1].to_f / duree_service * 100
      ligne[2] = ligne[2].to_f / duree_service * 100
    end

    graphe_temp = Array.new
    graphe.each do |ligne|
      ligne_temp = Array.new
      ligne_temp << ligne[0] << ligne[1]
      ligne_temp << ( ligne[2] - ligne[1] )
      ligne_temp << 100 - ligne[2]
      ligne_temp << ligne[2]
      graphe_temp << ligne_temp
    end
    graphe = graphe_temp

    graphe

  end

end