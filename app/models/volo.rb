class Volo < ActiveRecord::Base
  
  attr_accessible :first_name, :last_name, :short_last_name

  has_many :services, :through => :servolos
  has_many :servolos
  
  validates :first_name, :presence => true
  validates :last_name,  :presence => true

  def to_s
    self.full_name
  end
  
  def full_name
    self.first_name + ' ' + self.last_name
  end

  def short_full_name
    if self.short_last_name
      self.first_name + ' ' + self.short_last_name
    else
      self.first_name
    end
  end
  
end