# coding: utf-8
class Service < ActiveRecord::Base
  
  attr_accessible :ends_at, :event_id, :starts_at

  belongs_to :event
  has_many :seritems
  has_many :volos, :through => :servolos
  has_many :servolos
  has_many :dispositifs, :through => :disposers
  has_many :disposers

  validates :event_id, :presence => true
  validates :starts_at, :presence => true
  validates :ends_at, :presence => true

  before_destroy :prevent_destroy_unless_service_empty

  def relative_ends_at
    diff = ends_at.to_i/86400 - starts_at.to_i/86400
    if ( diff == 0 )
      self.ends_at.to_s(:cust_time)
    else
      self.ends_at.to_s(:cust_time) + " (+" + diff.to_s + ")"
    end
  end
  
  def fromto
    self.to_s
  end
  
  def to_s
    self.starts_at.to_s(:cust_short) + " → " + self.relative_ends_at
  end
  
private
  def prevent_destroy_unless_service_empty
    self.errors.add :base, "Service not empty"
      unless ( self.seritems.empty? && self.volos.empty? && self.dispositifs.empty? )
        false 
      end
  end

end
