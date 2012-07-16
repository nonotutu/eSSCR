# coding: utf-8
class Service < ActiveRecord::Base
  
  attr_accessible :event_id,
                  :starts_at,
                  :ends_at,
                  :rendezvous,
                  :depart_at,
                  :surplace_at,
                  :volness

  belongs_to :event
  has_many :seritems
  has_many :volos, :through => :servolos
  has_many :servolos
  has_many :dispositifs, :through => :disposers
  has_many :disposers

  validates :event_id, :presence => true
  validates :starts_at, :presence => true
  validates :ends_at, :presence => true
  validate  :start_before_end
  validate  :depart_before_surplace
  validate  :depart_before_start
  validate  :surplace_before_start

  before_destroy :prevent_destroy_unless_service_empty

  scope :only_year, lambda { |year| where("SUBSTR(starts_at,1,4) = ?", year) unless year.nil? }
  scope :only_not_invoiced, includes(:event).where("events.invoice_id IS NULL")
  scope :only_future, where("starts_at > ?", '2012-06-11')

  scope :by_date, order(:starts_at)
  scope :by_name, joins(:event).order(:name)
  
  def début
    return self.depart_at ||= self.surplace_at ||= self.starts_at
  end

  def disposers_to_inline
    if self.disposers.count > 0
      str = ""
      self.disposers.each do |dispo|
        str += dispo.quantity.to_s + " × " + dispo.dispositif.name + " ; "
      end
      str = str.chomp(" ; ")
    else
      "─ no disposers ─"
    end
  end

  def relative_depart_at
    if depart_at.present?
      diff = depart_at.to_i/86400 - starts_at.to_i/86400
      if ( diff == 0 )
        self.depart_at.to_s(:cust_time)
      elsif ( diff > 0 )
        self.depart_at.to_s(:cust_time) + " (+" + diff.to_s + ")"
      else
        self.depart_at.to_s(:cust_time) + " (" + diff.to_s + ")"
      end
    end
  end

  def durée_to_seconds
    self.ends_at - self.début
  end
  
  def durée_to_human_readable
    h = (durée_to_seconds.to_i)/1.hour
    m = (durée_to_seconds.to_i-h*1.hour)/1.minute
    str = h.to_s + " h " + m.to_s + " m"
  end

  def relative_surplace_at
    if surplace_at.present?
      diff = surplace_at.to_i/86400 - starts_at.to_i/86400
      if ( diff == 0 )
        self.surplace_at.to_s(:cust_time)
      elsif ( diff > 0 )
        self.surplace_at.to_s(:cust_time) + " (+" + diff.to_s + ")"
      else
        self.surplace_at.to_s(:cust_time) + " (" + diff.to_s + ")"
      end
    end
  end

  def relative_ends_at
    diff = ends_at.to_i/86400 - starts_at.to_i/86400
    if ( diff == 0 )
      self.ends_at.to_s(:cust_time)
    elsif ( diff > 0 )
      self.ends_at.to_s(:cust_time) + " (+" + diff.to_s + ")"
    else
      self.ends_at.to_s(:cust_time) + " (" + diff.to_s + ")"
    end
  end
  
#   def fromto
#     self.to_s
#   end
  
  def to_s
    self.starts_at.to_s(:cust_jdate) + " - " + self.starts_at.to_s(:cust_time) + " → " + self.relative_ends_at
  end

  private
  def prevent_destroy_unless_service_empty
    unless ( self.seritems.empty? && self.volos.empty? && self.dispositifs.empty? )
      self.errors.add :base, "Service not empty"
    end
  end

  def start_before_end
    if ( self.starts_at && self.ends_at )
      unless self.starts_at < self.ends_at
        self.errors.add :base, "Starts_at not before ends_at"
      end
    end
  end

  def depart_before_surplace
    if ( self.depart_at && self.surplace_at )
      unless self.depart_at < self.surplace_at
        self.errors.add :base, "Depart_at not before surplace_at"
      end
    end
  end

  def depart_before_start
    if ( self.depart_at && self.starts_at )
      unless self.depart_at < self.starts_at
        self.errors.add :base, "Depart_at not before starts_at"
      end
    end
  end

  def surplace_before_start
    if ( self.surplace_at && self.starts_at )
      unless self.surplace_at < self.starts_at
        self.errors.add :base, "Surplace_at not before starts_at"
      end
    end
  end

end