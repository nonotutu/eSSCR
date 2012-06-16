class CreateTableServolos < ActiveRecord::Migration

   def change

    create_table :servolos do |t|

      t.integer :service_id
      t.integer :volo_id

      t.timestamps  :starts_at
      t.timestamps  :ends_at

      t.timestamps

    end
    
  end
    
end
