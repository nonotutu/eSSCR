#encoding: utf-8

module ApplicationHelper

  def age(birth_date)
    age = Date.today - birth_date
    (age / 365.25).to_i
  end

  def nb_jours_to_annif(birth_date)
    annif = birth_date + (Date.today.year - birth_date.year).years
    if ( annif < Date.today )
      annif = annif + 1.years
    end
    nb = (annif - Date.today).to_i
  end
  
  def humanize_time_range(secs)
    (((secs/1.hour*100).to_i)/100.0).to_s + "h"
#   TODO : faire mieux
  end
  
  def event_last_year()
    begin Service.order(:ends_at).last.ends_at.year rescue 2010 end
  end

  def invoice_last_year()
    begin Invoice.order(:number).last.number[0..3].to_i rescue 2010 end
  end
  
  def to_euro(number)
    number_to_currency(number, :separator => ',', :delimiter => ' ', :unit => "€", :format => "%n %u", :negative_format => "- %n %u")
  end
  
  def to_percent(number)
    number_to_currency(number, :separator => ',', :delimiter => ' ', :unit => "%", :format => "%n %u", :negative_format => "- %n %u")
#   TODO : faire mieux
  end


  def calcul_prix_all_services_form_one_event(event_id)
    event = Event.find(event_id)
    tot = BigDecimal.new("0.0")
    event.services.each do |service|
      tot += calcul_prix_service_included(service.id)
    end
      
    return tot
    
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

  
  def calcul_prix_invoice(invoice_id)
        
    total_invoice = BigDecimal.new("0.0")
    invoice = Invoice.find(invoice_id)
    invoice.events.each do |event|
      total_event = BigDecimal.new("0.0")
      event.services.each do |service|
        total_service = BigDecimal.new("0.0")
        service.seritems.order(:pos).each do |seritem|
          ligne = Array.new
          if seritem.kind == 1
            total_service += seritem.qty * seritem.price
          elsif seritem.kind == 2
            total_service += total_service * seritem.price / BigDecimal("100.0")
          end
        end
        total_event += total_service
      end
      event.evitems.order(:pos).each do |evitem|
        if evitem.kind == 1
          total_event += evitem.qty * evitem.price
        elsif evitem.kind == 2
          total_event += total_event * evitem.price / BigDecimal("100.0")
        end
      end
      total_invoice += total_event
    end
    invoice.nositems.order(:pos).each do |nositem|
      if nositem.kind == 1
        total_invoice += nositem.qty * nositem.price
      elsif nositem.kind == 2
        total_invoice += total_invoice * nositem.price / BigDecimal("100.0")
      end
    end

    total_invoice
    
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
    service.seritems.order(:pos).each do |item|
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
      service.event.evitems.order(:pos).each do |item|
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
      service.event.invoice.nositems.order(:pos).each do |item|
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

    event.services.order.each do |service|
      total += calcul_prix_service(service.id)
    end
    if total > 0
      ligne = Array.new
      ligne << 3 << nil << "Services related items" << nil << nil << to_euro(total)
      table << ligne
    end

    tot = BigDecimal.new("0.0")
    event.evitems.order(:pos).each do |item|
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
      event.invoice.nositems.order(:pos).each do |item|
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
    ligne << 3 << nil << "Events/Services related items" << nil << nil << to_euro(total)
    table << ligne

    tot = BigDecimal.new("0.0")
    invoice.nositems.order(:pos).each do |item|
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
        service.seritems.order(:pos).each do |item|
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

    event.evitems.order(:pos).each do |item|
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
    
    service.servolos.by_first_name.each do |servolo|
      ligne = Array.new
      ligne << servolo.volo.full_name_avec_crentite
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



  def string_total_servolos(service_id)
    
    table = Array.new
    
    total = total_servolos(service_id)
    
    service = Service.find(service_id)
        
    max = service.volness ||= 0
    i = 0
    while i < total.count-1
      if max > total[i+2]
        table << "de " +
            (service.début + total[i].seconds).to_s(:cust_short) +
            " à " +
            (service.début + total[i+1].seconds).to_s(:cust_short) +
            " : " +
            (max - total[i+2]).to_s +
            " volontaire" +
            ((max-total[i+2])>1?"s":"")
      end
      i += 3
    end
    
    return table

  end
  
  
  
  def tableau_total_servolos(service_id)
        
    ligne7 = total_servolos(service_id)
    
    service = Service.find(service_id)
    duree = service.ends_at - (service.depart_at ||= service.surplace_at ||= service.starts_at)
    
    ligne8 = Array.new
    
#     max = -1
    i = 0
    fin = true
    while fin
      
#       if max < ligne7[i+2]
#         max = ligne7[i+2]
#       end

      ligne8 << ligne7[i+2] << (ligne7[i+1] - ligne7[i]) / duree.to_f * 100.0

      i += 3
      if i >= ( ligne7.count)
        fin = false
      end
    end
    
#     ligne8 << max
    
    return ligne8
    
  end


  
  def total_servolos(service_id)
    
    service = Service.find(service_id)
    
    table = Array.new
    ligne1 = Array.new
    ligne2 = Array.new
    ligne3 = Array.new
    ligne4 = Array.new
    ligne5 = Array.new
    ligne6 = Array.new
    ligne7 = Array.new
    
    debut = service.depart_at ||= service.surplace_at ||= service.starts_at
    duree = service.ends_at - debut
       
    service.servolos.each do |servolo|
      ligne1 << servolo.starts_at - debut
      ligne2 << servolo.ends_at - debut
    end

    ligne1.sort!
    ligne2.sort!
    
    i = 0
    j = 0
    v = 0
    while ( i < ligne1.count && j < ligne2.count )
       if ligne1[i] > ligne2[j]
         ligne3 << ligne2[j]
         ligne4 << v -= 1
         j += 1
       else
         ligne3 << ligne1[i]
         i += 1
         ligne4 << v += 1
       end
    end
        
    if i >= ligne1.count
      for k in j..ligne2.count-1
        ligne3 << ligne2[k]
        ligne4 << v -= 1
      end
    else
      for k in i..ligne1.count-1
        ligne3 << ligne1[k]
        ligne4 << v += 1
      end
    end

    
    # si le premier volo commence au début du service
    if ligne3[0] != 0.0
      ligne3.insert(0,0.0)
      ligne4.insert(0,0)
    end
    
    
    for i in 0..ligne4.count
      unless ligne3[i] == ligne3[i+1]
        ligne5 << ligne3[i]
        ligne6 << ligne4[i]
      end
    end

    # si le dernier volo termine à la fin du service
    if ligne5.last != (service.ends_at - debut)
      ligne5 << (service.ends_at - debut)
    else
      ligne6.delete_at(ligne6.count-1)
    end
    
    # table des intervalles
    for i in 0..ligne6.count-1
      ligne7 << ligne5[i]
      ligne7 << ligne5[i+1]
      ligne7 << ligne6[i]
    end
    
#   0    1  2    3    4  5    ... 
# début fin nb début fin nb ...
    
    fin = true
    i = 0
    while fin
      if ligne7[i+2] == ligne7[i+5]
        ligne7.delete_at(i+1)
        ligne7.delete_at(i+1)
        ligne7.delete_at(i+1)
      else
        i += 3
      end

      if i >= ( ligne7.count - 3 )
        fin = false
      end
      
    end
    
    return ligne7
    
  end


  # mode decal
  def generate_table_fullitems_event(event_id)
    
    table = Array.new
      
    event = Event.find(event_id)
    
    total_event = BigDecimal.new("0.0")
    event.services.each do |service|
        
      ligne = Array.new
      ligne << "2service" << service.to_s
      table << ligne
       
      total_service = BigDecimal.new("0.0")
      service.seritems.order(:pos).each do |seritem|
        ligne = Array.new
        if seritem.kind == 1
          ligne << "3seritem" << seritem.name << seritem.qty << to_euro(seritem.price) << to_euro(seritem.qty * seritem.price)
          total_service += seritem.qty * seritem.price
        elsif seritem.kind == 2
          ligne << "3seritem" << seritem.name << '' << to_percent(seritem.price) << to_euro(total_service * seritem.price / BigDecimal("100.0"))
          total_service += total_service * seritem.price / BigDecimal("100.0")
        end
        table << ligne
      end
      
      if service.seritems.count > 1
        ligne = Array.new
        ligne << "2sstot_service" << to_euro(total_service)
        table << ligne
      end
      total_event += total_service
      
    end

    if event.services.count > 1
      ligne = Array.new
      ligne << "1sstot_services" << event.name << to_euro(total_event)
      table << ligne
    end
      
    event.evitems.order(:pos).each do |evitem|
      ligne = Array.new
      if evitem.kind == 1
        ligne << "1evitem" << evitem.name << evitem.qty << to_euro(evitem.price) << to_euro(evitem.qty * evitem.price)
        total_event += evitem.qty * evitem.price
      elsif evitem.kind == 2
        ligne << "1evitem" << evitem.name << "" << to_percent(evitem.price)  << to_euro(total_event * evitem.price / BigDecimal("100.0"))
        total_event += total_event * evitem.price / BigDecimal("100.0")
      end
      table << ligne
    end

     
    ligne = Array.new
    ligne << "1total" << to_euro(total_event)
    table << ligne
    
    table
    
  end

  
  # mode decal
  def generate_table_fullitems_invoice(invoice_id)
    
    table = Array.new
    total_invoice = BigDecimal.new("0.0")
    
    invoice = Invoice.find(invoice_id)
    invoice.events.by_date.each do |event|
      
      ligne = Array.new
      ligne << "2event" << event.to_s
      table << ligne
      
      total_event = BigDecimal.new("0.0")
      event.services.each do |service|
        
        ligne = Array.new
        ligne << "3service" << service.to_s
        table << ligne
          
        total_service = BigDecimal.new("0.0")
        service.seritems.order(:pos).each do |seritem|
          ligne = Array.new
          if seritem.kind == 1
            ligne << "4seritem" << seritem.name << seritem.qty << to_euro(seritem.price) << to_euro(seritem.qty * seritem.price)
            total_service += seritem.qty * seritem.price
          elsif seritem.kind == 2
            ligne << "4seritem" << seritem.name << '' << to_percent(seritem.price) << to_euro(total_service * seritem.price / BigDecimal("100.0"))
            total_service += total_service * seritem.price / BigDecimal("100.0")
          end
          table << ligne
        end
        
        if service.seritems.count > 1
          ligne = Array.new
          ligne << "3sstot_service" << to_euro(total_service)
          table << ligne
        end
        total_event += total_service
        
      end

      if event.services.order(:starts_at).count > 1
        ligne = Array.new
        ligne << "2sstot_services" << event.name << to_euro(total_event)
        table << ligne
      end
        
      event.evitems.order(:pos).each do |evitem|
        ligne = Array.new
        if evitem.kind == 1
          ligne << "2evitem" << evitem.name << evitem.qty << to_euro(evitem.price) << to_euro(evitem.qty * evitem.price)
          total_event += evitem.qty * evitem.price
        elsif evitem.kind == 2
          ligne << "2evitem" << evitem.name << "" << to_percent(evitem.price)  << to_euro(total_event * evitem.price / BigDecimal("100.0"))
          total_event += total_event * evitem.price / BigDecimal("100.0")
        end
        table << ligne
      end

      if event.evitems.count > 1 || event.services.count > 1
        ligne = Array.new
        ligne << "2sstot_event" << event.name << to_euro(total_event)
        table << ligne
      end
      total_invoice += total_event
     
    end

    if invoice.events.count > 1
      ligne = Array.new
      ligne << "1sstot_events" << to_euro(total_invoice)
      table << ligne
    end

    invoice.nositems.order(:pos).each do |nositem|
      ligne = Array.new
      if nositem.kind == 1
        ligne << "1nositem" << nositem.name << nositem.qty << to_euro(nositem.price)  << to_euro(nositem.qty * nositem.price)
        total_invoice += nositem.qty * nositem.price
      elsif nositem.kind == 2
        ligne << "1nositem" << nositem.name << "" << to_percent(nositem.price)  << to_euro(total_invoice * nositem.price / BigDecimal("100.0"))
        total_invoice += total_invoice * nositem.price / BigDecimal("100.0")
      end
      table << ligne
    end

    ligne = Array.new
    ligne << "1total" << to_euro(total_invoice)
    table << ligne
    
    table
    
  end

  
  def event_total_stats(event_id)
    
    event = Event.find(event_id)
    
    stats = [0,0,0,0,0,0,0,0]
    
    event.services.each do |service|
      unless service.stats_t4.nil?
        stats[0] += service.stats_t4
        stats[1] += service.stats_t3
        stats[2] += service.stats_t2
        stats[3] += service.stats_t1
        stats[4] += service.stats_ambu
        stats[5] += service.stats_pit
        stats[6] += service.stats_smur
        stats[7] += service.stats_dcd
      end
    end
    
    stats
    
  end
    
  
end