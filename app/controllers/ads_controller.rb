class AdsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  include PagesHelper
  require 'open-uri'
  require 'digest/sha1'
  layout 'application'
  
  def index
      @ad = Ad.new 
      
  end

  def new 
      @ad = Ad.new
      
  end
  
  def error
  end
  
  def create
    @ad = Ad.new(post_params)
    title_img = @ad.title
    img_id = @ad.id
    valid_title = true
    if title_img.match(/\A[a-zA-Z0-9]*\z/).nil?
        valid_title = false #if the title has anything other then a-z etc 
    else
       flash[:error] = 'Only Alphabetic and number characters are allowed'
       
    end
    @user = User.find_by_email(@ad[:author])
    upload_limit = @user[:limit]
    if @user.ready == true && valid_title
      if upload_limit.to_i > 0 || @user.subscribed?
        @ad.save #vertiy photo is jpeg,gif, or png
        @user.update_attributes(:ready => false)
        @ad.update_attributes(:feedback => "", :rating => "", :recon => "", :adtype => "", :adstatus => "") #if image upload fails
        s3_path = "https://techauriga.s3.amazonaws.com/uploads/ad/image/#{@ad[:id]}/#{@ad[:image]}"
        directory_name = "public/uploads/#{@ad[:id]}"
        Dir.mkdir(directory_name) unless File.exists?(directory_name)
        IO.copy_stream(open(s3_path), "public/uploads/#{@ad[:id]}/#{@ad[:image]}")
        image_path = "public/uploads/#{@ad[:id]}/#{@ad[:image]}"

        classify = `python db/classify_image.py --image_file #{image_path}`
        ad_rating = `python db/rating_alg.py #{image_path} #{@ad[:id]}`
        calling = `python db/feedback_alg.py #{image_path}`
        color_status = `python db/color_alg.py #{image_path}`
          number_uploads = @user[:limit]
          if !current_user.subscribed
            number_uploads = @user[:limit]
            number_uploads -= 1
          else
            number_uploads = 0 #So users cant just pay and then cancel payment to get more uploads
          end
          @user.update_attributes(:limit => number_uploads, :ready => true)
          run_result = ad_rating[Integer(ad_rating.index('RATING_CLASS')) + 12..Integer(ad_rating.index('RATING_SCORE'))-1]
          run_score = ad_rating[Integer(ad_rating.index('RATING_SCORE')) + 13..-1]
          puts "Results: " + run_result
          puts "Classify: " + classify
          puts "Call to action: " + calling
          puts "Color status:" + color_status
          ad_type = classify[0..Integer(classify.index('('))-1]
          classify = classify[Integer(classify.index('=')) + 1..Integer(classify.index('=')) + 5]
          @ad.update_attributes(:feedback => calling, :rating => run_score, :recon => classify, :adtype => ad_type, :adstatus => run_result, :adcolor => color_status)
          redirect_to :action => :index
      else
          # @ad.destroy  # destroy if not enough limits
          flash[:error] = "Out of uploads for this month"
          redirect_to :action => :error 
      end
     else
       # @ad.destroy # Destory if its not ready or valid title
   end 
      #redirect_to ads_path(@ad)
  end  # end of function
  
  def show
    @ad = Ad.find(params[:id])        
  end
  helper_method :all
end
  