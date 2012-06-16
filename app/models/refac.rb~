class Refac < ActiveRecord::Base
  
  attr_accessible :crentite_id, :event_id, :price, :kind
  
  belongs_to :crentite
  belongs_to :event
  
  validates :crentite_id, :presence => true
  validates :event_id,    :presence => true
  validates :price,       :presence => true
  validates :kind,        :presence => true

end
