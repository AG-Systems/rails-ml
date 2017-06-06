class AdsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  include PagesHelper
  require 'open-uri'
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
        @ad.update_attributes(:feedback => "", :rating => "", :recon => "") #if image upload fails
        s3_path = "https://techauriga.s3.amazonaws.com/uploads/ad/image/#{@ad[:id]}/#{@ad[:image]}"
        directory_name = "public/uploads/#{@ad[:id]}"
        Dir.mkdir(directory_name) unless File.exists?(directory_name)
        IO.copy_stream(open(s3_path), "public/uploads/#{@ad[:id]}/#{@ad[:image]}")
        image_path = "public/uploads/#{@ad[:id]}/#{@ad[:image]}"
        begin
          if current_user.subscribed
            #classify = `python db/classify_image.py --image_file #{image_path}`
            classify=""
          else
            classify="" #classify_image takes up too much power at the moment          
          end
        rescue
            classify = "Image must be a jpg for image recognition to work. Stay tuned!"
        end
          
          result = `python db/feedback_alg.py  #{image_path}`
          ad_rating = `python db/rating_alg.py #{image_path} #{@ad[:id]}`
          number_uploads = @user[:limit]
          if !current_user.subscribed
            number_uploads = @user[:limit]
            number_uploads -= 1
          else
            number_uploads = 1 #So users cant just pay and then cancel payment to get more uploads
          end
          @user.update_attributes(:limit => number_uploads, :ready => true)
          
          
          if classify.length >= 500
            print(classify.length)
            print(classify)
            temp = classify.index('bytes.')
            temp = Integer(temp) + 6
            classify = classify[temp..-1]
          end
          puts ad_rating
          index_rating = ad_rating.index('RATING_SCORE')
          index_class = ad_rating.index('RATING_CLASS')
          index_feedback = ad_rating.index('RATING_FEEDBACK')
          index_rating = Integer(index_rating) + 12 
          run_status = ad_rating[(index_class.to_i + 12)..(index_rating.to_i-13)]
          feedback_rating = ad_rating[(index_feedback + 15)..-1]
          
          ad_rating = ad_rating[index_rating..(index_feedback.to_i - 1)]
          result += "\n #{feedback_rating}"
          result += "\n Results: #{run_status}"
          
          @ad.update_attributes(:feedback => result, :rating => ad_rating, :recon => classify)
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
  