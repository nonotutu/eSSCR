class AddColumnPaidAtDatetimeToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :paid_at, :timestamps
  end
end
