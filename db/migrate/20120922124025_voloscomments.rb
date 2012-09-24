class Voloscomments < ActiveRecord::Migration

  change_table :volos do |t|
    t.remove :comment
    t.text :comment
  end
        
end
