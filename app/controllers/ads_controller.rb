class AdsController < ApplicationController
  include PagesHelper
  require 'open-uri'
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
      @ad.update_attributes(:feedback => "", :rating => "", :recon => "") #if image upload fails
      s3_path = "https://techauriga.s3.amazonaws.com/uploads/ad/image/#{@ad[:id]}/#{@ad[:image]}"
      Dir.mkdir("public/uploads/#{@ad[:id]}")
      IO.copy_stream(open(s3_path), "public/uploads/#{@ad[:id]}/#{@ad[:image]}")
      image_path = "public/uploads/#{@ad[:id]}/#{@ad[:image]}"
      begin
        classify = `python db/classify_image.py --image_file #{image_path}`
        #classify = "test"
      rescue
        classify = "Image must be a jpg for image recognition to work. Stay tuned!"
      end
      result = `python db/feedback_alg.py  #{image_path}`
      ad_rating = `python db/rating_alg.py #{image_path}`
      if classify.length >= 500
          print(classify.length)
          print(classify)
          temp = classify.index('bytes.')
          #classify = "Testing"
          #classify.slice(classify.index("bytes.")..-1)
          classify = classify[temp+6..-1]
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
  