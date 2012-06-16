class Crentite < ActiveRecord::Base
  
  attr_accessible :name

  has_many :disposers
  
  validates :name, :presence => true
  
end