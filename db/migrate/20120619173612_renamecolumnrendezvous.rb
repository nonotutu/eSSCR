class Renamecolumnrendezvous < ActiveRecord::Migration

  def change
    rename_column :services, :rdv, :rendezvous
  end

end
