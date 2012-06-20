class Renamecolumnrdv < ActiveRecord::Migration
  def change
    rename_column :services, :rdv_at, :surplace_at
  end
end
