class Category < ActiveRecord::Base
  
  attr_accessible :name, :short_name

  has_many :events

  validates :name, :presence => true
  validates :short_name, :presence => true

end