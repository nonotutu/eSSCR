class AddColumns < ActiveRecord::Migration
  
  def change
    add_column :services, :rdv, :string
    add_column :services, :rdv_at, :datetime
    add_column :services, :depart_at, :datetime
  end

end
