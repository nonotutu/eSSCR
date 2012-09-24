#encoding : utf-8

class Event < ActiveRecord::Base
  
  attr_accessible :invoice_id, :category_id, :customer_id, :name, :place, :address, :ref, :is_free
  
  belongs_to :invoice
  belongs_to :category
  belongs_to :customer
  
  has_many :services
  has_many :evitems
  has_many :crentites, :through => :refacs
  has_many :refacs
  
  validates :category_id, :presence => true
  validates :name,        :presence => true
  validates :ref,         :presence => true
  validates :ref,         :format => { :with => /^[2][0][012][0-9][-][0-9][0-9][0-9][ARS]$/ }
  
  before_destroy :prevent_destroy_unless_event_empty, :notice => "Event not empty"

  scope :only_without_services, lambda { includes(:services) - Event.joins(:services) }
  scope :only_without_invoice_and_not_free, where(:invoice_id => nil).where(:is_free => false)
  
  scope :by_date, includes(:services).order("services.starts_at")

  def to_s
    self.name
  end
  
  def is_finished
    if self.services.count > 0
      if self.services.order(:ends_at).last.fin < DateTime.now
        true
      else
        false
      end
    else
      false
    end
      
  end
  
  def how_many_volos_still_needed
    total = 0
    self.services.each do |service|
      total += service.how_many_volos_still_needed
    end
    total
  end

  def is_complet
    self.how_many_volos_still_needed == 0 ? true : false
  end
  
  def status
    unless self.is_finished
      unless self.is_complet
        {:texte => "besoin de volontaires", :code => 3}
      else
        {:texte => "à venir / en cours", :code => 2}
      end
    else
      unless self.is_free || self.invoice
        {:texte => "à facturer", :code => 3}
      else
        {:texte => "terminé", :code => 1}
      end
    end
  end
  
  
  def calcul_prix

    total = BigDecimal("0.0")
    self.services.each do |service|
      total += service.calcul_prix
    end
    
    sstot = BigDecimal("0.0")
    self.evitems.each do |evitem|
      if evitem.kind == 1
        sstot = evitem.qty * evitem.price
      elsif evitem.kind == 2
        sstot = total * evitem.price / BigDecimal("100.0")
      end
      total = total + sstot
    end

    total

  end
  
  
  def calcul_prix_refacturation
    
    if self.refacs
      total_facture = self.calcul_prix
      total_refac = 0
      self.refacs.each do |refac|
        if refac.kind == 1
          total_refac += refac.price
        elsif refac.kind == 2
          total_refac += total_facture * refac.price / BigDecimal("100.0")
        end
      end
      return total_refac
    else
      return 0
    end
    
  end


private
  def prevent_destroy_unless_event_empty
    self.errors.add :base, "Event not empty"
      unless ( self.services.empty? && self.evitems.empty? && self.invoice_id == nil )
        false 
      end
  end
  
end
