class Champssuppsvolos < ActiveRecord::Migration
  def change
    add_column :volos, :comment, :string
    add_column :volos, :birth_date, :date
    add_column :volos, :local_date, :date
  end
end
