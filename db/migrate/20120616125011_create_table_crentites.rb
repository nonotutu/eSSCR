class CreateTableCrentites < ActiveRecord::Migration

   def change

    create_table :crentites do |t|

      t.string :name
      
      t.timestamps

    end

  end

end
