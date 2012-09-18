class Addcolumnsactiftovolos < ActiveRecord::Migration
  def change

    add_column :volos, :actif, :boolean
    
  end

end
