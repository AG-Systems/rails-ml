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
      begin
        classify = `python db/classify_image.py --image_file #{image_path}`
      rescue
        classify = "Image must be a jpg for image recognition to work. Stay tuned!"
      end
      result = `python db/feedback_alg.py  #{image_path}`
      ad_rating = `python db/rating_alg.py #{image_path}`
      if classify.length >= 50
          #temp = classif.index('bytes.')
          classify.slice(s.index("bytes.")..-1)
      end
      @ad.update_attributes(:feedback => result, :rating => ad_rating, :recon => classify)
      redirect_to :action => :index
      #redirect_to ads_path(@ad)
  end
  
  def show
    @ad = Ad.find(params[:id])        
  end
  helper_method :all
end
  