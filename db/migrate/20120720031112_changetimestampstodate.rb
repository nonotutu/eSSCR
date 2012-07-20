class Changetimestampstodate < ActiveRecord::Migration
  def change
    remove_column :invoices, :paid_at
    add_column :invoices, :paid_at, :date
  end
end
