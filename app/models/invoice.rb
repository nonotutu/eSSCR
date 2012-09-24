# encoding: utf-8

# 
# 1.9.3p194 :017 > Invoice.includes(:events).group("invoices.id").count.count
#    (0.9ms)  SELECT COUNT(*) AS count_all, invoices.id AS invoices_id FROM "invoices" GROUP BY invoices.id
#  => 5 
# 1.9.3p194 :018 > Invoice.joins(:events).group("invoices.id").count.count
#    (0.9ms)  SELECT COUNT(*) AS count_all, invoices.id AS invoices_id FROM "invoices" INNER JOIN "events" ON "events"."invoice_id" = "invoices"."id" GROUP BY invoices.id
#  => 2 
# 
# 3 sans events
# 
# 
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
  scope :only_with_events, joins(:events).group("invoices.id")
  scope :only_without_events, (includes(:events) - joins(:events))
  scope :wnw_events
  scope :only_sent_not_paid, where("sent_at IS NOT NULL AND paid_at IS NULL")
  scope :only_not_sent, where("sent_at IS NULL")

  def to_s
    self.number + ( self.customer_data_to_s ? ( " - " + self.customer_data_to_s ) : "" )
  end
  
  def customer_data_to_s
    ( self.customer_data.present? ? ( self.customer_data.lines.first ) : "" )
  end
  
  
  
  def calcul_prix
    
    total = BigDecimal.new("0.0")
    
    self.events.each do |event|
      total += event.calcul_prix
    end
    
    self.nositems.order(:pos).each do |nositem|
      if nositem.kind == 1
        total += nositem.qty * nositem.price
      elsif nositem.kind == 2
        total += total * nositem.price / BigDecimal("100.0")
      end
    end

    total
    
  end
  
# ✔✘
  def status
    if self.paid_at.present?
      if self.paid_at > DateTime.now
        { :texte => "erreur", :symbole => "⚠" }
      end
      if self.sent_at.present?
        { :texte => "payée ↔ " + (self.paid_at - self.sent_at).to_i.to_s + " jours", :symbole => "✔" }
      else
        { :texte => "erreur", :symbole => "⚠" }
      end
    else
      if (self.sent_at.present?)
        if self.sent_at > DateTime.now
          { :texte => "erreur", :symbole => "⚠" }
        end
        { :texte => "attente ↶ " + ((DateTime.now - self.sent_at)).to_i.to_s + " jours", :symbole => "⌛" }
      else
        { :texte => "à envoyer", :symbole => "✉" }
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
