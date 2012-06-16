class CreateInvoiceItemTemplates < ActiveRecord::Migration

  def change

    create_table :invoice_item_templates do |t|

      t.integer :pos
      t.string  :name
      t.integer :kind
      t.decimal :price

      t.timestamps

    end

  end

end
