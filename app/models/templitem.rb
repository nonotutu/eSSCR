# coding: utf-8
class Templitem < ActiveRecord::Base
  
  attr_accessible :pos, :name, :kind, :price
  
  validates :pos, :numericality => { :greater_than => 0 }
  validates :name, :presence => true
  validate  :kind_is_one_or_two
  validates :price, :presence => true
  
  def kind_is_one_or_two
    self.kind == 1 || self.kind == 2
  end
  
  def kind_to_long_s
    if self.kind == 1
      return 'euros'
    elsif self.kind == 2
      return 'pourcent'
    end
  end

end
