class Addreferencetoevents < ActiveRecord::Migration
  def change
    add_column :events, :ref, :string
  end

end
