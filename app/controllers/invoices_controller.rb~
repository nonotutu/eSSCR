# encoding: utf-8

class InvoicesController < InheritedResources::Base

  def show
    generate_liste
    @invoice = Invoice.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        pdf = InvoicePdf.new(@invoice)
        send_data pdf.render, filename: "invoice_#{@invoice.created_at.strftime("%d/%m/%Y")}.pdf", type: "application/pdf"
      end
    end
  end
  
  
  def edit
    generate_liste
    @invoice = Invoice.find(params[:id])
  end
  
  
  def index
  
    # génération des tableaux de liste de choix
    @annees = Array.new
    @annees << { :value => "all", :name => "········" } #☰☱☳☷☶☴☰☵☲
    2010.upto ( 2012 ) { |i| # TODO : invoice_last_year()
      @annees << { :value => i.to_s, :name => i.to_s } }

    @categs = Array.new
    @categs << { :value => "0", :name => "········" }
    @categs << { :value => "1", :name => "avec événement(s)" }
    @categs << { :value => "2", :name => "sans événement" }

    @sens = Array.new
    @sens << { :value => "up", :name => "↑↑" }
    @sens << { :value => "down", :name => "↓↓" }

    @status = Array.new
    @status << { :value => '-1', :name => "erreur" }
    @status << { :value => '1', :name => "payée" }
    @status << { :value => '2', :name => "à envoyer" }
    @status << { :value => '3', :name => "en attente de paiement" }

    generate_liste
    
  end

  
  def events
    generate_liste
    @invoice = Invoice.find(params[:id])
    #@events_without_invoice = Event.where(:invoice_id => nil).where(:is_free => false)
  end

  
  def overview
    generate_liste
    @invoice = Invoice.find(params[:id])
  end

  
  def new
    @invoice = Invoice.new
    @invoice.number = begin Invoice.order(:number).last.number.next rescue "2010-001" end
  end
  
  
protected

  def generate_liste

    # assignation des choix, premièrement si paramètres, deuxièmement, si variables de session
    annee  = params[:annee]  ||= session[:invoices_annee]
    categ  = params[:categ]  ||= session[:invoices_categ]
    sens   = params[:sens]   ||= session[:invoices_sens]   ||= 'up'
    status = params[:status] ||= session[:invoices_status]

    @invoices = Invoice #doit être scopé. (le sera au minimum sur le sens)
    
    # affutage selon les paramètres ou les sessions 
    if annee && annee != 'all'
        @invoices = @invoices.only_year(annee)
    end

    if categ
      case categ
      when '1'
        @invoices = @invoices.only_with_events
      when '2'
        @invoices = @invoices.only_without_events
      end
    end
 
    if sens && sens == 'down'
      @invoices = @invoices.reverse
    else # sens == 'up'
      @invoices = @invoices.all
    end
    
  end

end
