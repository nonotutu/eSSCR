# coding: utf-8
class Invoice < ActiveRecord::Base
  
  attr_accessible :number, :customer_data, :sent_at, :paid_at
  
  has_many :events
  has_many :nositems
  
  validates :number, :length => { :is => 8 }
  validates :number, :presence => true
  validates :number, :uniqueness => true
  validates :number, :format => {:with => /^20\d\d-\d\d\d$/}
  
  before_destroy :prevent_destroy_unless_empty

  scope :only_year, lambda { |year| where("SUBSTR(number,1,4) = ?", year) unless year.nil? }
  scope :only_with_events
  scope :only_without_events
  
  def to_s
    self.number + ( self.customer_data.present? ? ( " - " + self.customer_data.lines.first ) : "" )
  end
  
  def status
    
    if self.paid_at.present?
      if self.paid_at > DateTime.now
        return "erreur"
      end
      return "payée"
    else
      if (self.sent_at.present?)
        if self.sent_at > DateTime.now
          return "erreur"
        end
        return "envoyée - attente paiement"
      else
        return "à envoyer"
      end
    end
  end
  
private
  def prevent_destroy_unless_empty # pas d'events, pas de date d'envoi, pas de nositems
    unless ( self.events.empty? && self.sent_at == nil && self.paid_at == nil && self.nositems.empty? )
      false 
    end
  end
  
end
