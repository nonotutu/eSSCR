class Renametabletemplitems < ActiveRecord::Migration

  def change
    rename_table :template_invoiced_items, :templitems
  end

end
