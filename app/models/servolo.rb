# coding: utf-8
class Servolo < ActiveRecord::Base

  attr_accessible :service_id, :volo_id, :starts_at, :ends_at
  
  belongs_to :volo
  belongs_to :service
  
  validates :service_id, :presence => true
  validates :volo_id,    :presence => true

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