class Dispositif < ActiveRecord::Base
  
  attr_accessible :name

  has_many :services, :through => :disposers
  has_many :disposers
  
  validates :name, :presence => true
  
end 
