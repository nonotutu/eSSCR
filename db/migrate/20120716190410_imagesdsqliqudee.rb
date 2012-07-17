class Imagesdsqliqudee < ActiveRecord::Migration

  def change
    add_column :dispositifs, :image_s2_binary_data, :binary
    add_column :dispositifs, :image_s2_content_type, :string
    add_column :dispositifs, :image_s2_filename, :string
  end
  def change
    add_column :dispositifs, :image_s4_binary_data, :binary
    add_column :dispositifs, :image_s4_content_type, :string
    add_column :dispositifs, :image_s4_filename, :string
  end

end
