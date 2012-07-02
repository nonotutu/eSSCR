class Nonsscr < ActiveRecord::Migration

  def change

    create_table :nonsscrs do |t|

      t.integer :invoice_id

      t.string  :name

      t.timestamps

    end

  end

end
