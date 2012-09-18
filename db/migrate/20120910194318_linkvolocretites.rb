class Linkvolocretites < ActiveRecord::Migration
  def change
    add_column :volos, :crentite_id, :integer
  end
end
