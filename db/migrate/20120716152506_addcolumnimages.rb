class Addcolumnimages < ActiveRecord::Migration
  def change
    add_column :dispositifs, :image_s1, :binary
    add_column :dispositifs, :image_s2, :binary
    add_column :dispositifs, :image_s4, :binary
  end

end
