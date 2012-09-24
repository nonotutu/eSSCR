# encoding: utf-8

class InvoicesController < InheritedResources::Base

  def show
    @invoice = Invoice.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        pdf = InvoicePdf.new(@invoice)
        send_data pdf.render, filename: "invoice_#{@invoice.created_at.strftime("%d/%m/%Y")}.pdf", type: "application/pdf"
      end
    end
  end
  
  
  def index
  
    # génération des tableaux de liste de choix
    @annees = Array.new
    2010.upto ( 2012 ) { |i| # TODO : invoice_last_year()
      @annees << { :value => i.to_s, :name => i.to_s } }

    @categs = Array.new
    @categs << { :value => "0", :name => "<toutes>" }
    @categs << { :value => "1", :name => "avec événement(s)" }
    @categs << { :value => "2", :name => "sans événement" }

    # assignation des choix, premièrement si paramètres, deuxièmement, si variables de session
    annee = params[:annee] ||= session[:invoices_annee]
    categ = params[:categ] ||= session[:invoices_categ]

    # si aucun paramètre ou session, génération de la liste de TOUS
    unless annee && categ
      @invoices = Invoice.order(:number).all
    else
      @invoices = Invoice.order(:number)
    end
    
    # affutage selon les paramètres ou les sessions 
    if annee
      @invoices = @invoices.only_year(annee)
    end

    if categ
      case categ
      when "1"
        @invoices = @invoices.only_with_events
      when "2"
        @invoices = @invoices.only_without_events
      end
    end
    
  end

  
  def events
    @invoice = Invoice.find(params[:id])
    @events_without_invoice = Event.where(:invoice_id => nil).where(:is_free => false)
  end

  def overview
    @invoice = Invoice.find(params[:id])
  end
  
  def new
    @invoice = Invoice.new
    @invoice.number = begin Invoice.order(:number).last.number.next rescue "2010-001" end
  end

end