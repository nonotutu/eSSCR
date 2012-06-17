class Customers < ActiveRecord::Migration

  def change

    create_table :customers do |t|
      
      t.text :data
      
      t.timestamps
    
    end
  
  end

end
