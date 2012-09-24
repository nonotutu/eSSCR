class AddColumnVolosSubsInteger < ActiveRecord::Migration

  def change
    add_column :services, :subs, :integer
  end

end
