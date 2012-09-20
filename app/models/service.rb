# coding: utf-8
class Service < ActiveRecord::Base
  
  attr_accessible :event_id,
                  :starts_at,
                  :ends_at,
                  :rendezvous,
                  :depart_at,
                  :surplace_at,
                  :volness,
                  :stats_t1, :stats_t2, :stats_t3, :stats_t4, :stats_ambu, :stats_pit, :stats_smur, :stats_dcd

  belongs_to :event
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

  scope :only_year, lambda  { |year| where("SUBSTR(starts_at,1,4) = ?", year) unless year.nil? }
  scope :only_categ, lambda { |categ| includes(:event).where("events.category_id = ?", categ) unless categ.nil? }
  scope :only_not_invoiced, includes(:event).where("events.invoice_id IS NULL") # TODO : OR = "" ?
  scope :only_future, where("starts_at >= ?", Date.today)
  scope :only_past, where("ends_at <= ?", Date.today)
  scope :only_find, lambda  { |find| includes(:event).where("events.name LIKE '%#{find}%'") unless find.nil? }
 
  scope :by_date, order(:starts_at)
  scope :by_name, joins(:event).order(:name)
  

  def is_finished
    if self.ends_at < DateTime.now
      true
    else
      false
    end
  end

  
  def how_many_volos_still_needed
    retour = Array.new
    point_temporel = self.debut+1.second
    while point_temporel <= self.fin
      nb_volos_sur_point = 0
      self.servolos.each do |servolo|
        if servolo.debut < point_temporel && servolo.fin >= point_temporel
          nb_volos_sur_point += 1
        end
      end
      retour << self.volness - nb_volos_sur_point
      point_temporel += 5.minute
    end
    retour.max
  end

  
  def is_complet
    if self.how_many_volos_still_needed == 0
      true
    end
    false
  end
  
  
  def status
    unless self.is_finished
      unless self.is_complet
        {:texte => "besoin de " + ( c = self.how_many_volos_still_needed).to_s + " volontaire" + ( c>1 ? "s" : "" ), :code => 3}
      else
        {:texte => "à venir / en cours", :code => 2}
      end
    else
      unless self.stats_t4
        {:texte => "statistiques à remplir", :code => 2}
      else
        {:texte => "terminé", :code => 1}
      end
    end
  end


  def début # enlever
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

#   def stats_t4
#     if read_attribute(:stats_t4) != nil
#       return self.stats_t4
#     else
#       "∅"
#     end
#   end
  
#   def disposers_to_inline
#     if self.disposers.count > 0
#       str = ""
#       self.disposers.each do |dispo|
#         str += dispo.quantity.to_s + " × " + dispo.dispositif.name + " ; "
#       end
#       str = str.chomp(" ; ")
#     else
#       "─ no disposers ─"
#     end
#   end

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
  
#   def fromto
#     self.to_s
#   end
  
  def to_s
    self.starts_at.to_s(:cust_jdate) + " - " + self.starts_at.to_s(:cust_time) + " → " + self.relative_ends_at
  end

  
  # Array des heures, par bloc de 5 minutes, en commençant avant la 1ère seconde
  def generate_ligne_heures
    ligne = Array.new
    pt = self.debut.to_i
    while pt <= (self.fin-1.second).to_i
      if pt%3600 == 0
        ligne << Time.at(pt).utc.hour
      else
        ligne << " "
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
    
  
  # Array : heures - horaires - présences
  def generate_table_heures_horaires_servolos

    table_servolos = self.generate_table_servolos
    
    ligne_totaux = Array.new
    ligne_totaux = [0] * (table_servolos.first.size-2)
    table_servolos.each do |ligne|
      i = 0
      while i < ligne.size-2
        ligne_totaux[i] += ligne[i]
        i += 1
      end
    end
    
    table = Array.new
    table << self.generate_ligne_heures
    table << self.generate_ligne_horaires
    table += table_servolos
    table << ligne_totaux
    table
  end
  
  
  private
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