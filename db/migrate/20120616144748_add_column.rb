class AddColumn < ActiveRecord::Migration

  def change

    add_column :refacs, :event_id, :integer
    
  end

end
