# coding: utf-8
class Servolo < ActiveRecord::Base

  attr_accessible :service_id, :volo_id, :starts_at, :ends_at, :rendezvous
  
  belongs_to :volo
  belongs_to :service
  
  validates :service_id, :presence => true
  validates :volo_id,    :presence => true

  validate  :rdv_is_nil_1_2
  validate  :starts_at_is_in_service_range
  validate  :ends_at_is_in_service_range
  validate  :durée_is_not_0
    
  scope :by_first_name, joins(:volo).order(:first_name)
    
  def rdv_is_nil_1_2
    if ( self.rendezvous != "1" && self.rendezvous != "2" )
      self.rendezvous = nil
    end
  end

  def durée_is_not_0
    if self.starts_at == self.ends_at
      self.starts_at = self.service.début
      self.ends_at = self.service.ends_at
    end
  end
  
  def starts_at_is_in_service_range
    if self.starts_at < self.service.début
      self.starts_at = self.service.début
    end
    if self.starts_at > self.service.ends_at
      self.starts_at = self.service.ends_at-5.minutes
    end
  end
  
  def ends_at_is_in_service_range
    if self.ends_at < self.service.début
      self.ends_at = self.service.début+5.minutes
    end
    if self.ends_at > self.service.ends_at
      self.ends_at = self.service.ends_at
    end
  end
  
  def rendezvous_to_s
    case self.rendezvous
      when "1"
        return "départ"
      when "2"
        return "sur place"
    end
  end
  
  def fromto
    self.starts_at.to_s(:cust_short) + " → " + self.relative_ends_at
  end
  
  def relative_ends_at
    diff = self.ends_at.to_i/86400 - self.starts_at.to_i/86400
    if ( diff == 0 )
      self.ends_at.to_s(:cust_time)
    else
      self.ends_at.to_s(:cust_time) + " (+" + diff.to_s + ")"
    end
  end
  
end