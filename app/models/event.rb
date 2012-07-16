class Event < ActiveRecord::Base
  
  attr_accessible :invoice_id, :category_id, :customer_id, :name
  
  belongs_to :invoice
  belongs_to :category
  belongs_to :customer
  
  has_many :services
  has_many :evitems
  has_many :crentites, :through => :refacs
  has_many :refacs
  
  validates :category_id, :presence => true
  validates :name,        :presence => true

  before_destroy :prevent_destroy_unless_event_empty, :notice => "caca"

  scope :only_without_services, lambda { includes(:services) - Event.joins(:services) }

private
  def prevent_destroy_unless_event_empty
    self.errors.add :base, "Event not empty"
      unless ( self.services.empty? && self.evitems.empty? && self.invoice_id == nil )
        false 
      end
  end
  
end
