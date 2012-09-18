#encoding: utf-8

class InvoicePdf < PdfFacture

  require "prawn/measurement_extensions"
  
  def initialize(invoice)
    super(:page_size => "A4", :margin => [20.mm,20.mm,20.mm,20.mm])
    @invoice = invoice
    
    registering_police_dejavusans
    registering_police_dejavusansmono
    
    font "DejaVuSans"
    
    header('sscr')
    
    move_down 8.mm
    
    cadre_adresse(@invoice.customer_data)
    
    move_down 8.mm
    
    la_date("Uccle", "")
    
    move_down 8.mm
    
    titre("FACTURE n° " + @invoice.number)
    
    move_down 8.mm
    
    bounding_box([bounds.left,cursor], :width => bounds.right-bounds.left) do
      fullitems_from_invoice(@invoice.id)
    end
    
    move_down 8.mm
    
    a_payer(to_euro(calcul_prix_invoice(@invoice.id)))
    
    move_down 8.mm
    
    conditions_facturation
    
    footer
    
  end

end


