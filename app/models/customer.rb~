class Customer < ActiveRecord::Base
  
  attr_accessible :data

  has_many :events
  
  validates :data, :presence => true
  
  def to_s
    self.data.lines.first
  end
  
end