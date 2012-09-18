class Addstatstoservice < ActiveRecord::Migration
  def change
    add_column :services, :stats_t1, :integer
    add_column :services, :stats_t2, :integer
    add_column :services, :stats_t3, :integer
    add_column :services, :stats_t4, :integer
    add_column :services, :stats_ambu, :integer
    add_column :services, :stats_pit, :integer
    add_column :services, :stats_smur, :integer
    add_column :services, :stats_dcd, :integer
  end

end
