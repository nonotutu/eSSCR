class Renamecolumnnositems < ActiveRecord::Migration

  def change
    rename_column :nositems, :nonsscr_id, :invoice_id
  end

end
