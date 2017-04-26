class AdsController < ApplicationController
  include PagesHelper
  layout 'application'
  def index
      @ad = Ad.new
  end

  def new
      @ad = Ad.new
  end
  def create
      @ad = Ad.new(post_params)
      @ad.save
      image_path = "public/uploads/ad/image/#{@ad[:id]}/#{@ad[:image]}"
      result = `python db/classify_image.py --image_file #{image_path}`
      ad_rating = `python db/alg.py #{image_path}`
      @ad.update_attributes(:feedback => result, :rating => ad_rating)
      redirect_to :action => :index
      #redirect_to ads_path(@ad)
  end
  
  def show
    @ad = Ad.find(params[:id])        
  end
  helper_method :all
end
  