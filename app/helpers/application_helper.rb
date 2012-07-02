module ApplicationHelper

  
  def event_last_year()
    begin Service.order(:ends_at).last.ends_at.year rescue 2010 end
  end

  def invoice_last_year()
    begin Invoice.order(:number).last.number[0..3].to_i rescue 2010 end
  end
  
  def to_euro(number)
    number_to_currency(number, :separator => ',', :delimiter => ' ', :unit => "&euro;", :format => "%n %u", :negative_format => "- %n %u")
  end

  
  def to_percent(number)
    number_to_currency(number, :separator => ',', :delimiter => ' ', :unit => "%", :format => "%n %u", :negative_format => "- %n %u") # TODO : faire mieux
  end


  def calcul_prix_service(service_id)

    service = Service.find(service_id)

    total, tot = BigDecimal.new("0.0")
    service.seritems.each do |item|
      if item.kind == 1
        tot = item.qty * item.price
      elsif item.kind == 2
        tot = total * item.price / BigDecimal.new("100.0")
      end
      total = total + tot
    end

    total
    
  end


  def calcul_prix_service_included(service_id)

    total = BigDecimal.new("0.0")
    service = Service.find(service_id)
    
    total = calcul_prix_service(service_id)
    
    tot = BigDecimal.new("0.0")
    service.event.evitems.each do |item|
      if item.kind == 2
        tot = total * item.price / BigDecimal.new("100.0")
      end
      total += tot
    end

    if service.event.invoice
      tot = BigDecimal.new("0.0")
      service.event.invoice.nositems.each do |item|
        if item.kind == 2
          tot = total * item.price / BigDecimal.new("100.0")
        end
        total += tot
      end
    end
      
    total
    
  end

  
  def calcul_prix_event(event_id)

    event = Event.find(event_id)

    total = BigDecimal("0.0")
    event.services.each do |service|
      total += calcul_prix_service(service.id)
    end
    
    tot = BigDecimal("0.0")
    event.evitems.each do |item|
      if item.kind == 1
        tot = item.qty * item.price
      elsif item.kind == 2
        tot = total * item.price / BigDecimal("100.0")
      end
      total = total + tot
    end

    total
    
  end

  
  def calcul_prix_event_included(event_id)

    event = Event.find(event_id)

    total = BigDecimal("0.0")
    event.services.each do |service|
      total += calcul_prix_service(service.id)
    end
    
    tot = BigDecimal("0.0")
    event.evitems.each do |item|
      if item.kind == 1
        tot = item.qty * item.price
      elsif item.kind == 2
        tot = total * item.price / BigDecimal("100.0")
      end
      total = total + tot
    end
    
    if event.invoice
      tot = BigDecimal.new("0.0")
      event.invoice.nositems.each do |item|
        if item.kind == 2
          tot = total * item.price / BigDecimal.new("100.0")
        end
        total += tot
      end
    end

    total
    
  end

  
#   [0]   1 : item
#         2 : sous-total
#         3 : total services related items
#         4 : total events related items
#         5 : total invoices related items
#         6 : total
#   [1]   item.id
#   [2]   item.name
#   [3]   item.qty
#   [4]   item.price
#   [5]   item.total
#   

  # TODO : ne pas afficher les lignes inutiles
  # TODO : version 2
  
  
  def generate_table_seritems(service_id)

    table = Array.new
    total = BigDecimal.new("0.0")

    service = Service.find(service_id)

#   Liste des seritems
    tot = BigDecimal.new("0.0")
    service.seritems.each do |item|
      ligne = Array.new
      ligne << 1 << item.id << item.name
      if item.kind == 1
        ligne << item.qty << to_euro(item.price)
        ligne << to_euro(tot = item.qty * item.price)
      elsif item.kind == 2
        ligne << nil << to_percent(item.price)
        ligne << to_euro(tot = total * item.price / BigDecimal.new("100.0"))
      end
      ligne << tot
      table << ligne
      total = total + tot
    end
#   Ligne du sous-total, s'il y a des evitems ou des nositems
    if service.event.evitems.where("evitems.kind = ?",2).count > 0 || (service.event.invoice && service.event.invoice.nositems.where("nositems.kind = ?",2).count > 0)
      ligne = Array.new
      ligne << 2 << nil << "Sous-total" << nil << nil << to_euro(total)
      table << ligne
    end
    
#   Liste des evitems_% s'il y en a
    if service.event.evitems.where("evitems.kind = ?",2).count > 0
      tot = BigDecimal.new("0.0")
      service.event.evitems.each do |item|
        if item.kind == 2
          tot = total * item.price / BigDecimal("100.0")
        end
        total += tot
      end
      ligne = Array.new
      ligne << 4 << nil << "Event related items" << nil << nil << to_euro(tot)
      table << ligne
    end

#   Liste des nositems, s'il y a une facture et des nositems_%
    if (service.event.invoice && service.event.invoice.nositems.where("nositems.kind = ?", 2).count > 0)
      tot = BigDecimal.new("0.0")
      service.event.invoice.nositems.each do |item|
        if item.kind == 2
          tot = total * item.price / BigDecimal("100.0")
        end
      end
      ligne = Array.new
      ligne << 5 << nil << "Invoice related items" << nil << nil << to_euro(tot)
      table << ligne
      total += tot
    end
#   Ligne du total général
    ligne = Array.new
    ligne << 6 << nil << 'Total' << nil << nil << to_euro(total)
    table << ligne
    
    table
    
  end


  def generate_table_evitems(event_id)

    table = Array.new
    total = BigDecimal.new("0.0")

    event = Event.find(event_id)

    event.services.each do |service|
      total += calcul_prix_service(service.id)
    end
    if total > 0
      ligne = Array.new
      ligne << 3 << nil << "Services related items" << nil << nil << to_euro(total)
      table << ligne
    end

    tot = BigDecimal.new("0.0")
    event.evitems.each do |item|
      ligne = Array.new
      ligne << 1 << item.id << item.name
      if item.kind == 1
        ligne << item.qty << to_euro(item.price)
        ligne << to_euro(tot = item.qty * item.price)
      elsif item.kind == 2
        ligne << nil << to_percent(item.price)
        ligne << to_euro(tot = total * item.price / BigDecimal.new("100.0"))
      end
      ligne << tot
      table << ligne
      total = total + tot
    end
#   Ligne du sous-total, s'il y a des nositems_%
    if (event.invoice && event.invoice.nositems.where("nositems.kind = ?",2).count > 0)
      ligne = Array.new
      ligne << 2 << nil << "Sous-total" << nil << nil << to_euro(total)
      table << ligne
    end
#   Liste des nositems_%, s'il y a une invoice et des nositems_%
    if (event.invoice && event.invoice.nositems.where("nositems.kind = ?", 2).count > 0)
      tot = BigDecimal.new("0.0")
      event.invoice.nositems.each do |item|
        if item.kind == 2
          tot = total * item.price / BigDecimal("100.0")
        end
      end
      ligne = Array.new
      ligne << 5 << nil << 'Invoice related items' << nil << nil << to_euro(tot)
      table << ligne
      total += tot
    end
#   Ligne du total général
    ligne = Array.new
    ligne << 6 << nil << 'Total' << nil << nil << to_euro(total)
    table << ligne
    
    table

  end


  def generate_table_nositems(invoice_id)

    table = Array.new
    total = BigDecimal.new("0.0")

    invoice = Invoice.find(invoice_id)
    
    invoice.events.each do |event|
      total += calcul_prix_event(event.id)
    end
    ligne = Array.new
    ligne << 3 << nil << "Events/ Services related items" << nil << nil << total
    table << ligne

    tot = BigDecimal.new("0.0")
    invoice.nositems.each do |item|
      ligne = Array.new
      ligne << 1 << item.id << item.name
      if item.kind == 1
        ligne << item.qty << to_euro(item.price)
        ligne << (tot = item.qty * item.price)
      elsif item.kind == 2
        ligne << nil << to_percent(item.price)
        ligne << (tot = total * item.price / BigDecimal.new("100.0"))
      end
      ligne << tot
      table << ligne
      total = total + tot
    end
    ligne = Array.new
    ligne << 2 << nil << "Total" << nil << nil << to_euro(total)
    table << ligne

    table
    
  end

  
# return : >=0 : erreur
#           -1 : service
#           -2 : seritem
#           -3 : sstot service
#           -4 : sstot services
#           -5 : evitem
#           -6 : total

  def table_event_fullitem(event_id)
    
    table = Array.new
    ligne = Array.new
  
    event = Event.find(event_id)
      
    total = BigDecimal("0.0")
    
    event.services.order("starts_at").each do |service|
      sstot = BigDecimal("0.0")
      if service.seritems.count > 0
        ligne = Array.new
        ligne << -1 << ( service.starts_at.to_s(:cust_short) + " - " + service.relative_ends_at )
        service.seritems.order('pos').each do |item|
          table << ligne
          ligne = Array.new
          ligne << -2
          ligne << item.name
          if item.kind == 1
            montant = item.price * item.qty
            ligne << item.qty
            ligne << to_euro(item.price)
          elsif item.kind == 2
            montant = sstot * item.price / BigDecimal.new("100.0")
            ligne << nil
            ligne << to_percent(item.price)
          end
          ligne << to_euro(montant)
          table << ligne
          sstot += montant
        end
      end
      total += sstot
      if service.seritems.count > 1
        ligne = Array.new
        ligne << -3 << "Sous-total" << to_euro(sstot)
        table << ligne
      end
    end
    ligne = Array.new
    ligne << -4 << "Sous-total services" << to_euro(total)
    table << ligne

    event.evitems.order('pos').each do |item|
      ligne = Array.new
      ligne << -5
      ligne << item.name
      if item.kind == 1
        montant = item.price * item.qty
        ligne << item.qty
        ligne << to_euro(item.price)
      elsif item.kind == 2
        montant = total * item.price / BigDecimal.new("100.0")
        ligne << nil
        ligne << to_percent(item.price)
      end
      ligne << to_euro(montant)
      table << ligne
      total += montant
    end
    ligne = Array.new
    ligne << -6 << "Total" << nil << nil << to_euro(total)
    table << ligne
    
    table
  
  end  
  


  
# retourne : 0 string :  espace du début à la première heure
#            1 boolean : espace de la dernière heure à la fin ?
#            2 integer : nombre d'heures
#            3 string :  espace entre 2 heures
#            4 string :  espace de la dernière heure à la fin
#            5 boolean : espace du début à la première heure ?
  
  def fct_calcul_tableau_heures(debut, fin_service)

    duree_service = fin_service - debut
    
    # si durée négative, retourne nil # TODO : nécessaire ?
    if ( duree_service <= 0 )
      nil
    end

    # TODO : améliorer
    # tableau de toutes les heures
    tableau = Array.new
    i = debut
    while i <= fin_service do
      if i%3600 == 0
        tableau << i - debut
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
  
  
  def fct_calcul_tableau_horaire(fin, debut, surplace = nil, depart = nil)

    if depart
      duree = fin - depart
    elsif surplace
      duree = fin - surplace
    else
      duree = fin - debut
    end
    
    # si durée négative, retourne nil # TODO : nécessaire ?
    if ( duree <= 0 )
      nil
    end

    d = Array.new
    tableau = Array.new
    
    # TODO : optimiser
    if depart && surplace
      d0 = ( surplace - depart ).to_f / duree * 100
      d1 = ( debut - surplace ).to_f / duree * 100
    elsif depart && !surplace
      d0 = ( debut - depart ).to_f / duree * 100
    elsif !depart && surplace
      d1 = ( debut - surplace ).to_f / duree * 100
    end

    d2 = ( fin - debut ).to_f / duree * 100

    tableau << ( d0 ? ( d0.to_s + "%" ) : nil )
    tableau << ( d1 ? ( d1.to_s + "%" ) : nil )
    tableau << d2.to_s + "%"

    tableau
    
  end

  
  def fct_calcul_tableau_servolos(service_id)
    
    service = Service.find(service_id)
    
    if service.depart_at
      debut = service.depart_at
    elsif service.surplace_at
      debut = service.surplace_at
    else
      debut = service.starts_at
    end
    
    duree_service = ( service.ends_at - debut ).to_i
    
    graphe = Array.new
    
    service.servolos.each do |servolo|
      ligne = Array.new
      ligne << servolo.volo.first_name
      debut_servolo = ( servolo.starts_at - debut ).to_i
      if debut_servolo < 0
        ligne << 0
      else
        ligne << debut_servolo
      end
      fin_servolo = ( servolo.ends_at - debut ).to_i
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