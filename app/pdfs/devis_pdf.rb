#encoding: utf-8

class DevisPdf < PdfFacture

  require "prawn/measurement_extensions"
  
  def initialize(event)
    super(:page_size => "A4", :margin => [20.mm,20.mm,20.mm,20.mm])

    registering_police_dejavusans
    registering_police_dejavusansmono

    font "DejaVuSans"
    
    header('sscr')
    
    move_down 8.mm
    
    cadre_adresse(event.customer.data)

    move_down 8.mm
    
    la_date("Uccle", "")

    move_down 8.mm
    
    titre("DEVIS")

    move_down 8.mm
    
    infos_event(event.id)
    
    move_down 8.mm
    
    bounding_box([bounds.left,cursor], :width => bounds.right-bounds.left) do
      fullitems_from_event(event.id)
    end

    move_down 8.mm
  
    conditions_facturation

      
    footer
    
  end

end


