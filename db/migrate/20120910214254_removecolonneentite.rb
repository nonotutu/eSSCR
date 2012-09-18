class Removecolonneentite < ActiveRecord::Migration

  def change
    remove_column :volos, :entite
  end

end
