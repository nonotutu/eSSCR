# coding: utf-8
class Service < ActiveRecord::Base
  
  attr_accessible :event_id,
                  :starts_at,
                  :ends_at,
                  :rendezvous,
                  :depart_at,
                  :surplace_at,
                  :volness,
                  :stats_t1, :stats_t2, :stats_t3, :stats_t4, :stats_ambu, :stats_pit, :stats_smur, :stats_dcd,
                  :subs,
                  :crentite_id

  belongs_to :event
  belongs_to :crentite
  has_many :seritems
  has_many :volos, :through => :servolos
  has_many :servolos
  has_many :dispositifs, :through => :disposers
  has_many :disposers

  validates :event_id, :presence => true
  validates :starts_at, :presence => true
  validates :ends_at, :presence => true
  validate  :start_before_end
  validate  :depart_before_surplace
  validate  :depart_before_start
  validate  :surplace_before_start

  before_destroy :prevent_destroy_unless_service_empty
  before_update :stats_to_zero

  scope :only_year, lambda  { |year| where('SUBSTR(services.starts_at,1,4) = ?', year.to_s) unless year.nil? }
  scope :only_categ, lambda { |categ| includes(:event).where('events.category_id = ?', categ) unless categ.nil? }
  scope :only_not_invoiced, includes(:event).where('events.invoice_id IS NULL') # TODO : OR = "" ?
  scope :only_future, where('services.starts_at >= ?', Date.today)
  scope :only_future_plus_7, where('services.starts_at >= ?', Date.today - 7.day)
  scope :only_past, where('services.ends_at <= ?', Date.today)
  scope :only_past_plus_7, where('services.ends_at <= ?', Date.today + 7.day)
  scope :only_find, lambda  { |find| includes(:event).where("events.name LIKE '%#{find}%' OR events.place LIKE '%#{find}%'" ) unless find.nil? }
  scope :only_customer, lambda { |client| includes(:event).where("events.customer_id = #{client}") unless client.nil? }
  scope :only_volo, lambda { |volo| includes(:volos).where("volos.id = #{volo}") unless volo.nil? }
  scope :only_date, lambda { |date| where('services.starts_at >= ? AND services.starts_at <= ?', date, date+1.day) unless date.nil? }

  scope :by_date, order('services.starts_at')
  scope :by_date_inverted, order('services.starts_at DESC')
  scope :by_name, joins(:event).order(:name)
  scope :by_name_inverted, joins(:event).order('events.name DESC')
  
  def subs_to_s
    if self.subs
      case self.subs
      when 0
        'non'
      when 1
        'oui'
      end
    else
      'non-défini'
    end
  end


  def is_finished
    if self.ends_at < DateTime.now
      true
    else
      false
    end
  end


  def how_many_volos_still_needed
    if self.volness
      nb = self.volness - self.generate_ligne_totaux_servolos.min
      nb >= 0 ? nb : 0
    else
      0
    end
  end

  
  def is_complet
    self.how_many_volos_still_needed == 0 ? true : false
  end
  
  
  def status
    unless self.is_finished
      unless self.is_complet
        {:texte => "besoin de " + ( c = self.how_many_volos_still_needed).to_s + " volontaire" + ( c>1 ? "s" : "" ), :code => 3}
      else
        if DateTime.now > self.debut && DateTime.now < self.fin # TODO : checker
          {:texte => "en cours", :code => 2}
        else
          {:texte => "à venir", :code => 2}
        end
      end
    else
      unless self.stats_t4
        {:texte => "statistiques à remplir", :code => 2}
      else
        {:texte => "terminé", :code => 1}
      end
    end
  end


  def début # TODO : à enlever, remplacé par debut (sans l'accent)
    debut
  end

  def debut
    return self.depart_at ||= self.surplace_at ||= self.starts_at
  end

  
  def fin
    return self.ends_at
  end
  
  
  def duree
    self.durée_to_seconds
  end


  def relative_depart_at
    if depart_at.present?
      diff = depart_at.to_i/86400 - starts_at.to_i/86400
      if ( diff == 0 )
        self.depart_at.to_s(:cust_time)
      elsif ( diff > 0 )
        self.depart_at.to_s(:cust_time) + " (+" + diff.to_s + ")"
      else
        self.depart_at.to_s(:cust_time) + " (" + diff.to_s + ")"
      end
    end
  end

  
  def durée_to_seconds
    self.ends_at - self.début
  end
  
  
  def durée_to_human_readable
    h = (durée_to_seconds.to_i)/1.hour
    m = (durée_to_seconds.to_i-h*1.hour)/1.minute
    str = h.to_s + " h " + ((m>0)?(m.to_s+" m"):"")
  end

  
  def relative_surplace_at
    if surplace_at.present?
      diff = surplace_at.to_i/86400 - starts_at.to_i/86400
      if ( diff == 0 )
        self.surplace_at.to_s(:cust_time)
      elsif ( diff > 0 )
        self.surplace_at.to_s(:cust_time) + " (+" + diff.to_s + ")"
      else
        self.surplace_at.to_s(:cust_time) + " (" + diff.to_s + ")"
      end
    end
  end

  
  def relative_ends_at
    diff = ends_at.to_i/86400 - starts_at.to_i/86400
    if ( diff == 0 )
      self.ends_at.to_s(:cust_time)
    elsif ( diff > 0 )
      self.ends_at.to_s(:cust_time) + " (+" + diff.to_s + ")"
    else
      self.ends_at.to_s(:cust_time) + " (" + diff.to_s + ")"
    end
  end
  
  
  def to_s
    if self.crentite
      self.starts_at.to_s(:cust_jdate) + " - " + self.starts_at.to_s(:cust_time) + " → " + self.relative_ends_at + " :: " + self.crentite.number
    else
      self.starts_at.to_s(:cust_jdate) + " - " + self.starts_at.to_s(:cust_time) + " → " + self.relative_ends_at
    end
  end

  def fullname
    self.event.name + " :: " + self.to_s
  end
  
  # Array des heures, par bloc de 5 minutes, en commençant avant la 1ère seconde
  def generate_ligne_heures
    ligne = Array.new
    pt = self.debut.to_i
    while pt <= (self.fin-1.second).to_i
      if pt%3600 == 0
        ligne << Time.at(pt).utc.hour
      else
        ligne << -1
      end
      pt += 5.minutes
    end
    ligne
  end
  
  
  # Array d'horaire, par bloc de 5 minutes, en commençant apres la 1ère seconde
  def generate_ligne_horaires
    ligne = Array.new
    pt = self.debut+1.second
    while pt <= self.fin
      if self.starts_at < pt
        ligne << 3
      elsif self.surplace_at && self.surplace_at < pt
        ligne << 2
      elsif self.depart_at && self.depart_at < pt
        ligne << 1
      else
        ligne << 0
      end
      pt += 5.minutes
    end
    ligne
  end
  
  
  # Array d'Array des présences de tous les servolos, par bloc de 5 minutes
  def generate_table_servolos
    table = Array.new
    self.servolos.by_first_name.each do |servolo|
      table << servolo.generate_ligne_servolo
    end
    table
  end

  
  # redondance de generate_table_servolos
  def generate_ligne_totaux_servolos
    tsv = self.generate_table_servolos
    if ( fin = tsv.size - 1 ) > 0
      largeur = tsv[0].size
    end
    # gestion des doublinscrits
    pos = 0
    while pos < fin
      if tsv[pos][largeur-1] == tsv[pos + 1][largeur-1]
        sspos = 0
        while sspos < largeur-2
          tsv[pos][sspos] += tsv[pos+1][sspos]
          sspos += 1
        end
        tsv.delete_at(pos+1) # supprimer la ligne
        fin -= 1 # reculer la fin
        pos -= 1 # réinitialiser le pos
      end
      pos += 1
    end
    # calcul des totaux
    ligne_totaux = Array.new
    ligne_totaux = [0] * nombre_de_blocs_de_5_minutes
    tsv.each do |ligne|
      i = 0
      while i < ligne.size-2
        ligne_totaux[i] += ligne[i] > 1 ? 1 : ligne[i] # vérification si un servolo est doublinscrit
        i += 1
      end
    end
    ligne_totaux
  end
    
  
  # Array : heures - horaires - présences
  # redondancé dans generate_ligne_totaux_servolos
  def generate_table_heures_horaires_servolos

    tsv = self.generate_table_servolos
    
    if ( fin = tsv.size - 1 ) > 0
      largeur = tsv[0].size
    end
    
    # gestion des doublinscrits
    pos = 0
    while pos < fin
      if tsv[pos][largeur-1] == tsv[pos + 1][largeur-1]
        sspos = 0
        while sspos < largeur-2
          tsv[pos][sspos] += tsv[pos+1][sspos]
          sspos += 1
        end
        tsv.delete_at(pos+1) # supprimer la ligne
        fin -= 1 # reculer la fin
        pos -= 1 # réinitialiser le pos
      end
      pos += 1
    end
    
    # calcul des totaux
    ligne_totaux = Array.new
    ligne_totaux = [0] * nombre_de_blocs_de_5_minutes
    tsv.each do |ligne|
      i = 0
      while i < ligne.size-2
        ligne_totaux[i] += ligne[i] > 1 ? 1 : ligne[i] # vérification si un servolo est doublinscrit
        i += 1
      end
    end
      
    table = Array.new
    table << self.generate_ligne_heures
    table << self.generate_ligne_horaires
    table += tsv
    table << ligne_totaux
    table
  end
  
  
  def calcul_prix
    
    total = BigDecimal.new("0.0")
    self.seritems.order(:pos).each do |seritem|
      if seritem.kind == 1
        total += seritem.qty * seritem.price
      elsif seritem.kind == 2
        total += total * seritem.price / BigDecimal.new("100.0")
      end
    end

    total
        
  end


  def calcul_prix_included

    total = BigDecimal.new("0.0")
    total = self.calcul_prix
    
    tot = BigDecimal.new("0.0")
    self.event.evitems.each do |item|
      if item.kind == 2
        tot = total * item.price / BigDecimal.new("100.0")
      end
      total += tot
    end

    if self.event.invoice
      tot = BigDecimal.new("0.0")
      self.event.invoice.nositems.each do |item|
        if item.kind == 2
          tot = total * item.price / BigDecimal.new("100.0")
        end
        total += tot
      end
    end
      
    total
    
  end

  
  private
  
  def nombre_de_blocs_de_5_minutes
    # (self.debut+1.second..self.fin).step(300).count
    if self.debut && self.fin
      count = 0
      pt = self.debut+1.second
      while pt <= self.fin
        count += 1
        pt += 5.minutes
      end
      count
    else
      0
    end
  end
  
  def prevent_destroy_unless_service_empty
    unless ( self.seritems.empty? && self.volos.empty? && self.dispositifs.empty? )
      self.errors.add :base, "Service not empty"
    end
  end

  def start_before_end
    if ( self.starts_at && self.ends_at )
      unless self.starts_at < self.ends_at
        self.errors.add :base, "Starts_at not before ends_at"
      end
    end
  end

  def depart_before_surplace
    if ( self.depart_at && self.surplace_at )
      unless self.depart_at < self.surplace_at
        self.errors.add :base, "Depart_at not before surplace_at"
      end
    end
  end

  def depart_before_start
    if ( self.depart_at && self.starts_at )
      unless self.depart_at < self.starts_at
        self.errors.add :base, "Depart_at not before starts_at"
      end
    end
  end

  def surplace_before_start
    if ( self.surplace_at && self.starts_at )
      unless self.surplace_at < self.starts_at
        self.errors.add :base, "Surplace_at not before starts_at"
      end
    end
  end
  
  def stats_to_zero
    if self.stats_ambu || self.stats_dcd || self.stats_pit || self.stats_smur || self.stats_t1 || self.stats_t2 || self.stats_t3 || self.stats_t4
      if !self.stats_ambu
        self.stats_ambu = 0
      end
      if !self.stats_dcd
        self.stats_dcd = 0
      end
      if !self.stats_pit
        self.stats_pit = 0
      end
      if !self.stats_smur
        self.stats_smur = 0
      end
      if !self.stats_t1
        self.stats_t1 = 0
      end
      if !self.stats_t2
        self.stats_t2 = 0
      end
      if !self.stats_t3
        self.stats_t3 = 0
      end
      if !self.stats_t4
        self.stats_t4 = 0
      end
    end
  end

end
