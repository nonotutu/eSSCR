class CreateEvents < ActiveRecord::Migration

  def change

    create_table :events do |t|

      t.integer :category_id
      t.integer :invoice_id

      t.string  :name

      t.timestamps

    end

  end

end
