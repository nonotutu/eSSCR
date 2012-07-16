class Disposer < ActiveRecord::Base

  attr_accessible :quantity, :service_id, :dispositif_id, :crentite_id, :starts_at, :ends_at
  
  belongs_to :dispositif
  belongs_to :service
  belongs_to :crentite
  
  validates :service_id, :presence => true
  validates :dispositif_id, :presence => true
  validates :quantity, :presence => true
  validates :quantity, :numericality => { :greater_than => 0, :less_than_or_equal_to => 64 }
  
end