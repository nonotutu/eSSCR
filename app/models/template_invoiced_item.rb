class TemplateInvoicedItem < ActiveRecord::Base
  
  attr_accessible :pos, :name, :kind, :price
  
  validates :pos, :numericality => { :greater_than => 0 }
  validates :name, :presence => true
  validate  :kind_is_one_or_two
  validates :price, :presence => true
  
  def kind_is_one_or_two
    self.kind == 1 || self.kind == 2
  end
    
end
