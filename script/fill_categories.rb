# encoding: utf-8

Category.delete_all

c = Category.new

c.name       = "Action préventive de secours"
c.short_name = "APS"
c.save
c.name       = "Plan d'intervention psychosocial"
c.short_name = "PIPS"
c.save
c.name	     = "Action sociale"
c.short_name = "AS"
c.save
c.name       = "Exercice simulation"
c.short_name = "MASH"
c.save
c.name       = "Plan d'intervention médical"
c.short_name = "PIM"
c.save