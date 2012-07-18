class Category < ActiveRecord::Base
  
  attr_accessible :name, :short_name

  has_many :events

  validates :name, :presence => true
  validates :short_name, :presence => true

  before_destroy :prevent_destroy_if_in_use, :notice => "Category in use"

private
  def prevent_destroy_if_in_use
    self.errors.add :base, "Category in use"
      unless ( self.events.empty? )
        false 
      end
  end

end