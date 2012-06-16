class Invoice < ActiveRecord::Base
  
  attr_accessible :number, :customer_data, :sent_at
  
  has_many :events
  
  validates :number, :length => { :is => 8 }
  validates :number, :presence => true
  
  before_destroy :prevent_destroy_unless_invoice_empty

  def to_s
    self.number
  end
  
private
  def prevent_destroy_unless_invoice_empty
    unless ( self.events.empty? && self.sent_at == nil )
      false 
    end
  end
  
end
