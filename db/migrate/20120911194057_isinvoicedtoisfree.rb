class Isinvoicedtoisfree < ActiveRecord::Migration

  def change
    rename_column :events, :is_invoiced, :is_free
  end

end
