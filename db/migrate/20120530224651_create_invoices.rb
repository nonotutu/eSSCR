class CreateInvoices < ActiveRecord::Migration

  def change

    create_table :invoices do |t|

      t.string :number
      t.text   :customer_data
      t.date   :sent_at

      t.timestamps

    end

  end

end
