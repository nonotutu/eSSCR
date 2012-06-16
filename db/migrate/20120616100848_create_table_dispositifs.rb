class CreateTableDispositifs < ActiveRecord::Migration

   def change

    create_table :dispositifs do |t|

      t.integer :pos
      t.string  :name

      t.timestamps

    end
    
  end
  
end
