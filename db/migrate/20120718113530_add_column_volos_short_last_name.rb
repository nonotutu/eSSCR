class AddColumnVolosShortLastName < ActiveRecord::Migration

  def change
    add_column :volos, :short_last_name, :string
  end

end
