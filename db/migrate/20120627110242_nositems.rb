class Nositems < ActiveRecord::Migration

  def change

    create_table :nositems do |t|

      t.integer :nonsscr_id

      t.integer :pos
      t.string  :name
      t.decimal :qty
      t.decimal :price
      t.integer :kind

      t.timestamps

    end

  end

end
