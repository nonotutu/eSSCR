class Customer < ActiveRecord::Base


  attr_accessible :data

  has_many :events
  
  validates :data, :presence => true

  before_destroy :prevent_destroy_if_in_use, :notice => "Customer in use"

  def to_s
    self.data.lines.first
  end
  
  def nb_events(annee = nil)
    unless annee
      self.events.count
    else
      self.events.only_year(annee).count.count
    end
  end

  def nb_services(annee = nil)
    s = 0
    unless annee
      self.events.each do |c|
        s += c.services.count
      end
    else
      self.events.only_year(annee).each do |c|
        s += c.services.count
      end
    end
    s
  end

  def nb_evt_srv(annee = nil)
    "#{self.nb_events(annee)}(#{self.nb_services(annee)})"
  end

  def nb_evt_paid(annee = nil)
    unless annee
      self.events.joins(:invoice).where('invoices.paid_at IS NOT NULL').count
    else
      self.events.only_year(annee).joins(:invoice).where('invoices.paid_at IS NOT NULL').count.count
    end
  end
  
  def nb_evt_notpaid(annee = nil)
    unless annee
      self.events.joins(:invoice).where('invoices.paid_at IS NULL').count
    else
      self.events.only_year(annee).joins(:invoice).where('invoices.paid_at IS NULL').count.count
    end
  end
  
  def calcul_prix_events(annee = nil)
    tot = BigDecimal("0,0")
    unless annee
      self.events.each do |event|
        tot += event.calcul_prix_included
      end
    else
      self.events.each do |event|
        event.services.only_year(annee.to_s).each do |service|
          tot += service.calcul_prix_included
        end
      end
    end
    tot
  end

private
  def prevent_destroy_if_in_use
    self.errors.add :base, "Customer in use"
      unless ( self.events.empty? )
        false 
      end
  end

    
end
