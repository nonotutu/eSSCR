# coding: utf-8
class Servolo < ActiveRecord::Base

  attr_accessible :service_id, :volo_id, :starts_at, :ends_at, :rendezvous
  
  belongs_to :volo
  belongs_to :service
  
  validates :service_id, :presence => true
  validates :volo_id,    :presence => true

  validate  :rdv_is_nil_1_2_3
  validate  :starts_at_is_in_service_range
  validate  :ends_at_is_in_service_range
  validate  :duree_is_not_0
    
  scope :by_first_name, joins(:volo).order(:first_name, :last_name)

  def debut
    if starts_at.nil?
      self.service.debut
    else
      self.starts_at
    end
  end
  
  def fin
    if ends_at.nil?
      self.service.fin
    else
      self.ends_at
    end
  end

  def rdv_is_nil_1_2_3
    if ( self.rendezvous != "1" && self.rendezvous != "2" && self.rendezvous != "3" )
      self.rendezvous = nil
    end
  end

  def duree_is_not_0
    if self.starts_at == self.service.debut
      self.starts_at = nil
    end
    if self.ends_at == self.service.fin
      self.ends_at = nil
    end
    if ( !self.starts_at.nil? || !self.ends_at.nil? )
      if self.debut >= self.fin
        self.starts_at = self.service.debut
        self.ends_at = self.service.fin
      end
    end
  end
  
  def starts_at_is_in_service_range
    unless self.starts_at.nil?
      if self.starts_at < self.service.debut
        self.starts_at = self.service.debut
      end
      if self.starts_at > self.service.fin
        self.starts_at = self.service.fin-5.minutes
      end
    end
  end
    
  def ends_at_is_in_service_range
    unless self.ends_at.nil?
      if self.ends_at < self.service.debut
        self.ends_at = self.service.debut+5.minutes
      end
      if self.ends_at > self.service.ends_at
        self.ends_at = self.service.ends_at
      end
    end
  end
  
  def rendezvous_to_s
    case self.rendezvous
      when '1'
        return 'départ'
      when '2'
        return 'sur place'
      when '3'
        return 'trajet'
    end
  end
  
  def fromto
    str = ""
    if (self.service.debut > self.debut) || (self.service.fin < self.fin)
      str += "⚠ "
    end
    str += self.debut.to_s(:cust_short) + " → " + self.relative_ends_at
    str
  end
  
  def relative_ends_at
    diff = self.fin.to_i/86400 - self.debut.to_i/86400
    if ( diff == 0 )
      self.fin.to_s(:cust_time)
    else
      self.fin.to_s(:cust_time) + " (+" + diff.to_s + ")"
    end
  end

  def duree_to_seconds
    self.fin - self.debut
  end

  def duree_to_human_readable
    h = (duree_to_seconds.to_i)/1.hour
    m = (duree_to_seconds.to_i-h*1.hour)/1.minute
    str = h.to_s + " h " + ((m>0)?(m.to_s+" m"):"")
  end
  
  
  # Array des présences d'un servolo, par bloc de 5 minutes
  def generate_ligne_servolo
    
#     nb_times_volo = self.service.servolos.where("volo_id = ?", self.volo.id).count
    
    ligne = Array.new
    pt = self.service.debut+1.second
    while pt <= self.service.fin
      if pt > self.debut && pt < self.fin
        ligne << 1
      else
        ligne << 0
      end
      pt += 5.minutes
    end
    ligne << self.volo.first_name << self.volo.full_name_avec_crentite
    ligne
  end
    

end