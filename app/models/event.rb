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
  
private
  def prevent_destroy_unless_event_empty
    self.errors.add :base, "Event not empty"
      unless ( self.services.empty? && self.evitems.empty? && self.invoice_id == nil )
        false 
      end
  end
  
end
