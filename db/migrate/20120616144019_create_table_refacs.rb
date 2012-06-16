class CreateTableRefacs < ActiveRecord::Migration

  def change

    create_table :refacs do |t|
    
      t.integer :crentite_id
      t.integer :kind
      t.decimal :price
      
      t.timestamps      
      
    end
    
  end

end
