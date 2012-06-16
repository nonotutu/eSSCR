class AlterTableDisposerAddColumnCrentiteId < ActiveRecord::Migration

  def change
    add_column :disposers, :crentite_id, :integer
  end

end
