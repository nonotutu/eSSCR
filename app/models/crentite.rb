class Crentite < ActiveRecord::Base
  
  attr_accessible :name

  has_many :disposers
  has_many :events, :through => :refacs
  has_many :refacs
  
  validates :name, :presence => true
  
end