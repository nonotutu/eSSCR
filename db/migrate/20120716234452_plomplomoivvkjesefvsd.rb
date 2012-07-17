class Plomplomoivvkjesefvsd < ActiveRecord::Migration

  def change
      add_column :events, :place, :string
      add_column :events, :address, :text
  end

end
