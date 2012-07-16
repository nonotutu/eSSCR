class Add < ActiveRecord::Migration
  def change
    add_column :servolos, :rendezvous, :string
  end

end
