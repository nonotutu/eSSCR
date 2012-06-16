class CreateTableDisposers < ActiveRecord::Migration

   def change

    create_table :disposers do |t|

      t.integer :service_id
      t.integer :dispositif_id

      t.integer :quantity

      t.timestamps

    end
    
  end

end
