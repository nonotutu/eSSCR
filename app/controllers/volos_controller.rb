class VolosController < InheritedResources::Base

  def overview
    @volo = Volo.find(params[:id])
  end
  
end