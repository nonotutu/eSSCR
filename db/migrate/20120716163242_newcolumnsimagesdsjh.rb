class Newcolumnsimagesdsjh < ActiveRecord::Migration

  def change
    rename_column :dispositifs, :image_s1, :image_s1_binary_data
    add_column :dispositifs, :image_s1_content_type, :string
    add_column :dispositifs, :image_s1_filename, :string
  end

end
