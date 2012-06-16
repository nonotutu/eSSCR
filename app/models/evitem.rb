class Evitem < ActiveRecord::Base
  
  attr_accessible :event_id, :pos, :name, :kind, :qty, :price
  
  belongs_to :event
  
  validates :event_id, :presence => true
  validates :pos, :numericality => { :greater_than => 0 }
  validates :name, :presence => true
  validate  :kind_is_one_or_two
  validate  :qty_is_not_nil_if_kind_is_1
  validates :price, :presence => true
  
  def kind_is_one_or_two
    self.kind == 1 || self.kind == 2
  end
  
  def qty_is_not_nil_if_kind_is_1
    if self.kind == 1
      if self.qty.nil?
        self.qty = 0
      end
    else
      self.qty = 0
    end
  end
  
end