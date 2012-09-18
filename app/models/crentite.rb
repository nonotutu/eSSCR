class Crentite < ActiveRecord::Base
  
  attr_accessible :name, :number, :long_name

  has_many :disposers
  has_many :events, :through => :refacs
  has_many :refacs
  has_many :volos
  
  validates :name, :presence => true
  
  before_destroy :prevent_destroy_if_in_use, :notice => "Crentite in use"
  
  def to_s
    self.name
  end
  
  def short
    if !self.number.empty?
      self.number
    else
      self.name
    end
  end

private
  def prevent_destroy_if_in_use
    self.errors.add :base, "Crentite in use"
      unless ( self.volos.empty? || self.disposers.empty? || self.events.empty? )
        false 
      end
  end

end