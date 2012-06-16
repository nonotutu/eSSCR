class Servolo < ActiveRecord::Base

  attr_accessible :service_id, :volo_id, :starts_at, :ends_at
  
  belongs_to :volo
  belongs_to :service
  
  validates :service_id, :presence => true
  validates :volo_id, :presence => true

end