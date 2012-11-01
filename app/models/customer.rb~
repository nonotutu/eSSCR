class Customer < ActiveRecord::Base
  
  attr_accessible :data

  has_many :events
  
  validates :data, :presence => true

  before_destroy :prevent_destroy_if_in_use, :notice => "Customer in use"

  def to_s
    self.data.lines.first
  end

private
  def prevent_destroy_if_in_use
    self.errors.add :base, "Customer in use"
      unless ( self.events.empty? )
        false 
      end
  end
    
end