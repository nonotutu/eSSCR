class AddVolnessToServices < ActiveRecord::Migration
  def change
    add_column :services, :volness, :integer
  end
end
