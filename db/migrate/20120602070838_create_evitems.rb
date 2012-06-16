class CreateEvitems < ActiveRecord::Migration

  def change

    create_table :evitems do |t|

      t.integer :event_id

      t.integer :pos
      t.string  :name
      t.decimal :qty
      t.decimal :price
      t.integer :kind

      t.timestamps

    end

  end

end