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
    if title_img.match(/\A[a-z0-9\s]+\Z/i).nil?
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
        extract_text = `python db/extract_text.py #{image_path}`
        text_size = `python db/text_graph.py #{image_path}`
        
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
          ad_type_confidence = classify[Integer(classify.index('=')) + 1..Integer(classify.index(')'))-1]
          puts "Results: " + run_result
          puts "Ad score: " + run_score
          puts "Classify: " + classify
          puts "Text: " + text_recon
          puts "Percent of text: " + extract_text
          puts "Total distance between text: " + text_size
          #puts "Ad memorability: " + calling
          #puts "Attention Grab:" + color_status
          puts "Brightness test: " + `python db/classify_brightness.py #{image_path}`
          puts "Ad Type: " + ad_type
          puts "Ad Type Confidence: " + ad_type_confidence
          feedback_results = feedback(ad_type , text_recon, extract_text, text_size, brightness_res, ad_type_confidence)
          
          classify = classify[Integer(classify.index('=')) + 1..Integer(classify.index('=')) + 5] #Image recon
          """
          if ad_rating.to_f == 0 or ad_rating.to_f >= 9 or (ad_rating.to_f >= 5 and ad_rating.to_f <= 6)
              new_rating = `python db/special_alg.py #{image_path} #{@ad[:id]} #{ad_type}`
              new_rating = new_rating[Integer(new_rating.index('RATING_SCORE')) + 13..-1]
              run_score = (run_score.to_f + Float(new_rating.to_f)) / 2
              run_score = run_score.to_s
              run_score = new_rating.to_f
              puts 'New rating: ' + new_rating.to_s
          end 
          """
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
  
  private 
  def feedback(adtype, text_recon, extract_text, text_size, brightness_res, ad_type_confidence)
      feedback_results = ""
      if adtype == "web site, website, internet site, site"
          temp = text_recon
          temp = temp.gsub(/\s+/, "")
          if temp.length > 40
            feedback_results = "You are using way too much text "
          elsif temp.length > 15
            feedback_results = "Try using less text "
          else
            if brightness_res.to_i > 180
              feedback_results = "Try decreasing brightness and/or contrast "
            elsif brightness_res.to_i < 30
              feedback_results = "Try increasing brightness and/or contrast "
            end
          end
          if extract_text.to_f >= 30 and text_recon.length > 10 and temp.length >= 10 and text_size.to_f <= 1000
            feedback_results = "Text takes up too much on your ad "
          end
          if text_size.to_f >= 20000 and extract_text.to_f <= 10
            feedback_results = "Your text might be too small "
          end
      elsif adtype == "sports car, sport car" or adtype.include? "car" or adtype.include? "radiator" or adtype.include? "convertible"
          if ad_type_confidence.to_f <= 0.6
            feedback_results = "Try zooming more onto the car or making the car more clear"
          end
          
    else
          temp = text_recon
          temp = temp.gsub(/\s+/, "")
          if temp.length > 40
            feedback_results = "You are using way too much text "
          elsif temp.length > 15
            feedback_results = "Try using less text "
          else
            if brightness_res.to_i > 180
              feedback_results = "Try decreasing brightness and/or contrast "
            elsif brightness_res.to_i < 30
              feedback_results = "Try increasing brightness and/or contrast "
            end
          end
          if extract_text.to_f >= 30 and text_recon.length > 10 and temp.length >= 10 and text_size.to_f <= 1000
            feedback_results = "Text takes up too much on your ad "
          end
          if text_size.to_f >= 20000 and extract_text.to_f <= 10
            feedback_results = "Your text might be too small "
          end     
      
    end
    
    return feedback_results
  end  
end
  