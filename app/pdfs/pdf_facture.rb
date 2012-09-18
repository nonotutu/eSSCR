#encoding: utf-8

class PdfFacture < Pdf

  include ApplicationHelper
  include ActionView::Helpers::NumberHelper
  
  
  def infos_event(event_id)

    font_size 11
    
    event = Event.find(event_id)
    
    bounding_box([bounds.left,cursor], :width => 40.mm, :height => 4.mm) do
      text "Événement :", :align => :right
    end
    bounding_box([bounds.left+44.mm,cursor+4.mm], :width => 126.mm) do
      text "#{event.name}", :style => :bold
    end
    
    move_down 4.mm
    
    event.services.order(:starts_at).each do |service|
      bounding_box([bounds.left+44.mm,cursor], :width => 126.mm) do
        text "· #{service.to_s}"
      end
    end
    
  end
  
  
  def a_payer(total)
    
    font_size 11

    bounding_box([bounds.left+22.mm,cursor], :width => 126.mm) do
      cell :background_color => 'E8E8D0', :width => bounds.right-bounds.left, :height => bounds.top-bounds.bottom, :align => :center, :text_color => "001B76"
      bounding_box([bounds.left+2.mm,bounds.top-2.mm], :width => 126.mm-2.mm) do
        font_size 11
        text "Total à payer : #{total}", :style => :bold
        text "Payable au comptant sur le compte ING BE90 3100 0858 8832"
        #stroke_bounds
      end
      move_down 1.mm
      stroke_bounds
    end
    
  end
  
  
  def conditions_facturation
  
    move_cursor_to bounds.bottom + 8.mm
    
    font_size 6
    
    text "La tarification est d'application du 1er janvier 2012 au 31 décembre 2013."
    text "Notre facturation est soumise aux conditions générales, disponibles sur simple demande."

  end

  def ligne_facture_headers

    font_size 11

    hauteur = 4.mm

    fill_color "AAAAAA"
    fill_rectangle [bounds.left,cursor+1.mm], 170.mm, hauteur+1.mm
    fill_color "000000"

    bounding_box([bounds.left+2.mm,cursor], :width => 95.mm-2.mm, :height => hauteur) do
      text "Dénomination"
    end
    bounding_box([bounds.left+95.mm+2.mm,cursor+hauteur], :width => 25.mm-2.mm, :height => hauteur) do
      text "Qté"
    end
    bounding_box([bounds.left+120.mm+2.mm,cursor+hauteur], :width => 25.mm-2.mm, :height => hauteur) do
      text "P/U"
    end
    bounding_box([bounds.left+145.mm+2.mm,cursor+hauteur], :width => 25.mm-2.mm, :height => hauteur) do
      text "Montant"
    end
    
    stroke_line [bounds.left,cursor+hauteur+1.mm], [bounds.right,cursor+hauteur+1.mm]
    stroke_line [bounds.left,cursor], [bounds.right,cursor]
    move_down 1.mm

  end

  def fullitems_from_event(event_id)
    
    table = generate_table_fullitems_event(event_id)
    
    ligne_facture_headers
        
    hauteur = 3.mm

    font_size 8
    
    table.each do |ligne|
      case ligne[0][1..(ligne[0].size-1)]
      when "service"
        facture_ligne_service(ligne, hauteur)
      when "seritem", "evitem"
        facture_ligne_item(ligne,hauteur)
      when "sstot_service"
        facture_ligne_sstot_service(ligne, hauteur)
      when "sstot_services"
        facture_ligne_sstot_services(ligne, hauteur)
      when "total"
        facture_ligne_total(ligne, hauteur)
      end
    end

    
  end


  def fullitems_from_invoice(invoice_id)

    table = generate_table_fullitems_invoice(invoice_id)
    
    ligne_facture_headers

    hauteur = 3.mm

    font_size 8
    
    table.each do |ligne|
      case ligne[0][1..(ligne[0].size-1)]
      when "event"
        facture_ligne_event(ligne, hauteur)
      when "service"
        facture_ligne_service(ligne, hauteur)
      when "seritem", "evitem", "nositem"
        facture_ligne_item(ligne,hauteur)
      when "sstot_service"
        facture_ligne_sstot_service(ligne, hauteur)
      when "sstot_services"
        facture_ligne_sstot_services(ligne, hauteur)
      when "sstot_event"
        facture_ligne_sstot_event(ligne, hauteur)
      when "sstot_events"
        facture_ligne_sstot_events(ligne, hauteur)
      when "total"
        facture_ligne_total(ligne, hauteur)
      end
    end
        
  end

  
  def facture_ligne_total(ligne, hauteur)
    decal = ligne[0][0].to_i - 1
    fill_color "CCCCCC"
    fill_rectangle [bounds.left+decal*4.mm,cursor], 170.mm-decal*4.mm, hauteur
    fill_color "000000"
    bounding_box([bounds.left+decal*4.mm,cursor], :width => 95.mm-decal*4.mm, :height => hauteur) do
      text "Total général", :style => :bold
    end
    bounding_box([bounds.left+95.mm,cursor+hauteur], :width => 75.mm, :height => hauteur) do
      font("DejaVuSansMono") do
        text "#{ligne[1]}", :style => :bold, :align => :right, :font_size => 12
      end
    end
    stroke_line [bounds.left+decal*4.mm,cursor], [bounds.right,cursor]
    move_down 1.mm
  end
  
  
  def facture_ligne_item(ligne, hauteur)
        
    decal = ligne[0][0].to_i - 1
    
    bounding_box([bounds.left+decal*4.mm,cursor], :width => 95.mm-decal*4.mm, :height => hauteur) do
      text "#{ligne[1]}"
    end
    bounding_box([bounds.left+95.mm,cursor+hauteur], :width => 25.mm, :height => hauteur) do
      font("DejaVuSansMono") do
        text "#{ligne[2]}", :align => :right
      end
    end
    bounding_box([bounds.left+120.mm,cursor+hauteur], :width => 25.mm, :height => hauteur) do
      font("DejaVuSansMono") do
        text "#{ligne[3]}", :align => :right
      end
    end
    bounding_box([bounds.left+145.mm,cursor+hauteur], :width => 25.mm, :height => hauteur) do
      font("DejaVuSansMono") do
        text "#{ligne[4]}", :align => :right
      end
    end

  end
  
  
  def facture_ligne_event(ligne, hauteur)
    
    decal = ligne[0][0].to_i - 1
    
    fill_color "CCCCCC"
    fill_rectangle [bounds.left+decal*4.mm,cursor], 170.mm-decal*4.mm, hauteur
    fill_color "000000"
    bounding_box([bounds.left+decal*4.mm,cursor], :width => 170-decal*4.mm, :height => hauteur) do
      text "#{ligne[1]}", :style => :italic
    end
  end

  
  def facture_ligne_service(ligne, hauteur)
    
    decal = ligne[0][0].to_i - 1
    
    fill_color "EEEEEE"
    fill_rectangle [bounds.left+decal*4.mm,cursor], 170.mm-decal*4.mm, hauteur
    fill_color "000000"
    bounding_box([bounds.left+decal*4.mm,cursor], :width => 170.mm-decal*4.mm, :height => hauteur) do
      text "#{ligne[1]}", :style => :italic
    end
  end

  
  def facture_ligne_sstot_service(ligne, hauteur)
  
    decal = ligne[0][0].to_i - 1

    fill_color "EEEEEE"
    fill_rectangle [bounds.left+decal*4.mm,cursor], 170.mm-decal*4.mm, hauteur
    fill_color "000000"
    bounding_box([bounds.left+decal*4.mm,cursor], :width => 95.mm-decal*4.mm, :height => hauteur) do
      text "Sous-total", :style => :italic
    end
    bounding_box([bounds.left+95.mm,cursor+hauteur], :width => 75.mm, :height => hauteur) do
      font("DejaVuSansMono") do
        text "#{ligne[1]}", :align => :right, :style => :italic
      end
    end
    stroke_line [bounds.left+decal*4.mm,cursor], [bounds.right,cursor]
    move_down 1.mm

  end
  
  
  def facture_ligne_sstot_services(ligne, hauteur)
    
    decal = ligne[0][0].to_i - 1
    fill_color "CCCCCC"
    fill_rectangle [bounds.left+decal*4.mm,cursor], 170.mm-decal*4.mm, hauteur
    fill_color "000000"
    bounding_box([bounds.left+decal*4.mm,cursor], :width => 95.mm-decal*4.mm, :height => hauteur) do
      text "Sous-total", :style => :italic
    end
    bounding_box([bounds.left+95.mm,cursor+hauteur], :width => 75.mm, :height => hauteur) do
      font("DejaVuSansMono") do
        text "#{ligne[2]}", :align => :right, :style => :italic
      end
    end
    
  end
  
  
  def facture_ligne_sstot_event(ligne, hauteur)
  
    decal = ligne[0][0].to_i - 1
    fill_color "CCCCCC"
    fill_rectangle [bounds.left+decal*4.mm,cursor], 170.mm-decal*4.mm, hauteur
    fill_color "000000"
    bounding_box([bounds.left+decal*4.mm,cursor], :width => 95.mm-decal*4.mm, :height => hauteur) do
      text "Total #{ligne[1]}", :style => :italic
    end
    bounding_box([bounds.left+95.mm,cursor+hauteur], :width => 75.mm, :height => hauteur) do
      font("DejaVuSansMono") do
        text "#{ligne[2]}", :align => :right, :style => :italic
      end
    end
    stroke_line [bounds.left+decal*4.mm,cursor], [bounds.right,cursor]
    move_down 1.mm

  end

  
  def facture_ligne_sstot_events(ligne, hauteur)
  
    decal = ligne[0][0].to_i - 1
    bounding_box([bounds.left+decal*4.mm,cursor], :width => 95.mm-decal*4.mm, :height => hauteur) do
      text "Sous-total général", :style => :italic
    end
    bounding_box([bounds.left+95.mm,cursor+hauteur], :width => 75.mm, :height => hauteur) do
      font("DejaVuSansMono") do
        text "#{ligne[1]}", :align => :right, :style => :italic
      end
    end
  end
  
end
