class Volo < ActiveRecord::Base
  
  attr_accessible :first_name, :last_name, :short_last_name, :entite

  has_many :services, :through => :servolos
  has_many :servolos
  
  validates :first_name, :presence => true
  validates :last_name,  :presence => true

  scope :only_uccle, where("entite = '0040'")
  scope :only_not_uccle, where("entite != '0040' OR entite IS NULL")

  
  def to_s
    self.full_name
  end
  
# Prénom Nom
# Prénom Nom (entité)
  def full_name
    if self.entite == "0040"
      self.first_name + " " + self.last_name
    else
      self.first_name + " " + self.last_name + " (" + (self.entite.to_s.empty? ? "ext." : self.entite) + ")"
    end
  end

# Prénom Nom_Court
# TODO : Garder ? Pourquoi ne pas faire un prénom court aussi ?
  def short_full_name
    if self.short_last_name
      self.first_name + ' ' + self.short_last_name
    else
      self.first_name
    end
  end
  
end