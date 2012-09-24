class Addcrentitetoservices < ActiveRecord::Migration

  def change
    add_column :services, :crentite_id, :integer
  end

end
