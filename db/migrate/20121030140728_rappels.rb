class Rappels < ActiveRecord::Migration

  def change
    add_column :invoices, :rappel1_at, :date
    add_column :invoices, :rappel2_at, :date
    add_column :invoices, :rappel3_at, :date
  end

end
