class Volo < ActiveRecord::Base
  
  attr_accessible :first_name, :last_name, :short_last_name, :crentite_id, :actif, :birth_date, :local_date, :comment

  belongs_to :crentite
  
  has_many :services, :through => :servolos
  has_many :servolos
  
  validates :first_name, :presence => true
  validates :last_name,  :presence => true
  
  scope :by_first_name, order(:first_name)
  scope :by_last_name, order(:last_name)
  scope :by_local_date, order(:local_date)
  
  scope :only_crentite, lambda { |id| where("crentite_id = ?", id) unless id.nil? }
  scope :only_not_crentite, lambda { |id| where("crentite_id != ?", id) unless id.nil? }
  
  scope :only_actif, where("actif = ?", true)
  scope :only_not_actif, where("actif != ?", true)
  
  scope :only_first_letter_of_first_name, lambda  { |letter| where("SUBSTR(UPPER(first_name),1,1) = ?", letter) unless letter.nil? }
  scope :only_first_letter_of_last_name, lambda  { |letter| where("SUBSTR(UPPER(last_name),1,1) = ?", letter) unless letter.nil? }

  def to_s
    self.full_name
  end

# Prénom Nom
# Prénom Nom (entité)
  def full_name
    self.first_name + " " + self.last_name
  end

  def full_name_avec_crentite
    self.first_name + " " + self.last_name + " (" + ( self.crentite.nil? ? "autre" : self.crentite.short ) + ")"
  end
  
end