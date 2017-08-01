class AdsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  include PagesHelper 
  require 'open-uri'
  include CarrierWave::MiniMagick
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
    if valid_title
      if upload_limit.to_i > 0 || @user.subscribed?
        @ad.save #vertiy photo is jpeg,gif, or png
        @user.update_attributes(:ready => false)
        @ad.update_attributes(:feedback => "", :rating => "", :recon => "", :adtype => "", :adstatus => "") #if image upload fails
        s3_path = "https://techauriga.s3.amazonaws.com/uploads/model_upload/image/#{@ad[:id]}/#{@ad[:image]}"
        directory_name = "public/uploads/#{@ad[:id]}"
        Dir.mkdir(directory_name) unless File.exists?(directory_name)
        IO.copy_stream(open(s3_path), "public/uploads/#{@ad[:id]}/#{@ad[:image]}")
        image_path = "public/uploads/#{@ad[:id]}/#{@ad[:image]}"
        image = MiniMagick::Image.new(image_path)
        image.format "jpg"
        classify = `python db/classify_image.py --image_file #{image_path}`
        ad_rating = `python db/rating_alg.py #{image_path} #{@ad[:id]}`
        #calling = `python db/feedback_alg.py #{image_path}`
        #color_status = `python db/color_alg.py #{image_path}`
        text_recon = `python db/classify_text.py #{image_path}`
        brightness_res = `python db/classify_brightness.py #{image_path}`
        feedback_results = ""
          number_uploads = @user[:limit]
          if !current_user.subscribed
            number_uploads = @user[:limit]
            number_uploads -= 1
          else
            number_uploads = 0 #So users cant just pay and then cancel payment to get more uploads
          end
          @user.update_attributes(:limit => number_uploads, :ready => true) #Reduce the number of uploads by 1 and make it so they can upload again 
          run_result = ad_rating[Integer(ad_rating.index('RATING_CLASS')) + 12..Integer(ad_rating.index('RATING_SCORE'))-1] #Run this ad or not
          run_score = ad_rating[Integer(ad_rating.index('RATING_SCORE')) + 13..-1] # Score
          ad_type = classify[0..Integer(classify.index('('))-1] #Maybe in the future, we can use this
          puts "Results: " + run_result
          puts "Ad score: " + run_score
          puts "Classify: " + classify
          puts "Text: " + text_recon
          #puts "Ad memorability: " + calling
          #puts "Attention Grab:" + color_status
          puts "Brightness test: " + `python db/classify_brightness.py #{image_path}`
          if text_recon.length > 25
            feedback_results = "You are using way too much text"
          elsif text_recon.length > 10
            feedback_results = "Try using less text"
          else
            if brightness_res.to_i > 180
              feedback_results = "Try decresing brightness and/or contrast"
            elsif brightness_res.to_i < 30
              feedback_results = "Try increasing brightness and/or contrast"
            end
          end
          puts "Ad Type: " + ad_type
          classify = classify[Integer(classify.index('=')) + 1..Integer(classify.index('=')) + 5] #Image recon
          
          #calling.chomp!
          #color_status.chomp!
          #calling = Float(calling)
          #color_status = Float(color_status)
          """
          if classify.to_f > 0.70
            calling = (calling * (1.2 + (classify.to_f - 0.70)))

            color_status = (color_status * (1.2 + (classify.to_f - 0.70)))
            puts 'Confident object dect'
          elsif classify.to_f < 0.10
              calling = (calling * 1.2)

              color_status = (color_status * 1.2)
              puts 'Ad is too unique' 
          else
              calling = (calling + (Float(run_score) * 0.5))
              
              color_status = (color_status + (Float(run_score) * 0.5))
          end
          calling = String(calling)
          color_status = String(color_status)
          if Float(calling) > 10.0
            calling = '10.0'
          end

          #calling = (calling.to_f)
          #color_status = (color_status.to_f)
          """
          #classify = (classify.to_f)
          
          #calling = String(calling)
          #color_status = String(color_status)
          #classify = String(classify) 
          """
          puts 'NEW SCORE: '
          puts run_score
          puts '-----------'
          new_rating = `python db/special_alg.py #{image_path} #{@ad[:id]} #{ad_type}`
          new_rating = new_rating[Integer(new_rating.index('RATING_SCORE')) + 13..-1]
          run_score = (run_score.to_f + Float(new_rating.to_f)) / 2
          run_score = run_score.to_s
          puts new_rating
          puts '----------------------'
          """
          if Float(run_score) <= 1.0 or Float(run_score) >= 9.0 
            puts
            puts "Score was low / high: Re-run time" 
            temp = ad_type
            temp = temp.gsub(/\s+/, "")
            new_rating = `python db/special_alg.py #{image_path} #{@ad[:id]} #{temp}`
            new_rating = new_rating[Integer(new_rating.index('RATING_SCORE')) + 13..-1]
            #run_score = (run_score.to_f + Float(new_rating.to_f)) / 2 #Take average or just keep new score
            run_score = run_score.to_s
            puts "New score: "
            puts run_score 
          end
          #@ad.update_attributes(:feedback => calling, :rating => run_score, :recon => classify.chomp, :adtype => ad_type, :adstatus => run_result.chomp, :adcolor => color_status.chomp)
          @ad.update_attributes(:rating => run_score, :adtype => ad_type, :adstatus => run_result.chomp, :feedback => feedback_results)
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
  