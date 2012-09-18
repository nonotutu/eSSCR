#encoding: utf-8

class Pdf < Prawn::Document

  def registering_police_dejavusanscondensed
    font_families.update("DejaVuSansCondensed" => {:normal      => "public/fonts/DejaVuSansCondensed.ttf",
                                                   :italic      => "public/fonts/DejaVuSansCondensed-Oblique.ttf",
                                                   :bold        => "public/fonts/DejaVuSansCondensed-Bold.ttf",
                                                   :bold_italic => "public/fonts/DejaVuSansCondensed-BoldOblique.ttf"
                                                  })
  end

  def registering_police_dejavusansmono
    font_families.update("DejaVuSansMono" => {:normal      => "public/fonts/DejaVuSansMono.ttf",
                                              :italic      => "public/fonts/DejaVuSansMono-Oblique.ttf",
                                              :bold        => "public/fonts/DejaVuSansMono-Bold.ttf",
                                              :bold_italic => "public/fonts/DejaVuSansMono-BoldOblique.ttf"
                                             })
  end

  def registering_police_dejavusans
    font_families.update("DejaVuSans" => {:normal      => "public/fonts/DejaVuSans.ttf",
                                          :italic      => "public/fonts/DejaVuSans-Oblique.ttf",
                                          :bold        => "public/fonts/DejaVuSans-Bold.ttf",
                                          :bold_italic => "public/fonts/DejaVuSans-BoldOblique.ttf"
                                         })
  end

  
  def header(categ)

    bounding_box([bounds.left-8.mm,bounds.top+10.mm], :width => bounds.right-bounds.left+16.mm, :height => 17.mm) do
      
      case(categ)
        when "sscr"
          font_size 8
          text "Croix-Rouge de Belgique"
          text "Section locale d'Uccle"
          text "Service de Secours", :style => :bold
          text "96 rue de Stalle"
          text "1180 Uccle"
        else    
          text "Header SL"
      end
      
      move_cursor_to bounds.top
      image "public/icons/logo_2293-563.png", :height => 14.mm, :position => :right
      
      move_cursor_to bounds.bottom
      stroke_line [bounds.left-2.mm,cursor-2.mm],[bounds.right+2.mm,cursor-2.mm]
      move_down 2.mm
      
    end
    
  end

  
  def cadre_adresse(adresse)

    bounding_box([bounds.left+85.mm,cursor], :width => bounds.right-bounds.left-85.mm) do
      bounding_box([bounds.left+2.mm,bounds.top-2.mm], :width => 81.mm) do
        font_size 11
        text "#{adresse}"
      end
      move_down 1.mm
      stroke_bounds
    end
    
  end

  
  def la_date(lieu, dadate)
  
    dadate = DateTime.now.to_s(:cust_longdate) if dadate == ''

    font_size 11
    text "#{lieu}, #{dadate}", :align => :right
    
  end
  
  
  def titre(titre)

    font_size 20
    
    bounding_box([bounds.left,cursor], :width => 170.mm) do
      stroke_horizontal_rule
      move_down 2.mm
      text "#{titre}", :align => :center
#      move_down 1.mm
      stroke_horizontal_rule

    end
    
  end
    
      
  def footer
    
    bounding_box([bounds.left-8.mm,bounds.bottom], :width => bounds.right-bounds.left+16.mm, :height => 8.mm) do
      
      define_grid(:columns => 13, :rows => 5, :column_gutter => 4)
      
      font_size 8
      
      grid([1,0], [2,0]).bounding_box do
        text "tel :", :align => :right
      end
      grid([3,0], [4,0]).bounding_box do
        text "e-mail :", :align => :right
      end
     
      grid([1,1], [2,5]).bounding_box do
        text "+ 32 (0) 477 931 255"
      end
      grid([3,1], [4,5]).bounding_box do
        text "secours@croix-rouge-uccle.be"
      end

      grid([1,7], [2,12]).bounding_box do
        text "Banque ING :  IBAN BE90 3100 0858 8832", :align => :right
      end
      grid([3,7], [4,12]).bounding_box do
        text "Swift BBRUBEBB", :align => :right
      end
      
      move_cursor_to bounds.top
      stroke_line [bounds.left-2.mm,cursor+2.mm],[bounds.right+2.mm,cursor+2.mm]
      
    end
    
  end
 

end