class CreateSeritems < ActiveRecord::Migration

  def change

    create_table :seritems do |t|

      t.integer :service_id

      t.integer :pos
      t.string  :name
      t.decimal :qty
      t.decimal :price
      t.integer :kind

      t.timestamps

    end

  end

end