class AddColumnEntiteToVolos < ActiveRecord::Migration
  def change
    add_column :volos, :entite, :string
  end
end
