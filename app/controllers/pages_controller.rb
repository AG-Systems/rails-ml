class PagesController < ApplicationController
  include PagesHelper
  layout 'application'
  

  
  def index
      @ad = Ad.new
      @images = Ad.all.order('created_at DESC').limit(1)

  end

  def new
      @ad = Ad.new
  end
  
  def results
      @images = Ad.all.order('created_at DESC') 
  end
  #def create
   #   @ad = Ad.new(post_params)
    #  result = `python db/script.py`
     # @ad.update_attributes(:rating => result)
      #@ad.save
  #    redirect_to ads_path(@ad)
#  end
  
  def show
    @ad = Ad.find(params[:id])    
  def support
  end
  end
  helper_method :all
end
