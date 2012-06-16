class Volo < ActiveRecord::Base
  
  attr_accessible :first_name, :last_name

  has_many :services, :through => :servolos
  has_many :servolos
  
  validates :first_name, :presence => true
  validates :last_name,  :presence => true

  def to_s
    self.first_name + ' ' + self.last_name
  end
  
end