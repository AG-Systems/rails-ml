libs:

Python dependencies:


      Tensorflow

      Sklearn
      
      TFLearn

      Pandas

      scipy

      pillow

      colorthief

      updated version of pip

      opencv-python
      
      h5py
      
      tqdm
Linux dependencies:


    tesseract-ocr


For heroku:

    heroku pg:reset DATABASE --app APP

    heroku run --app APP rake db:schema:load

    heroku run --app APP rake db:migrate

    heroku buildpacks:add https://github.com/oswellchan/heroku-buildpack-tesseract
    
    heroku buildpacks:add https://github.com/computationaltextiles/ct-buildpack-python-opencv.git
    
    heroku buildpacks:add https://github.com/orchardmile/heroku-buildpack-numpy-scipy.git
    
    1) Python
    
    2) https://github.com/orchardmile/heroku-buildpack-numpy-scipy.git
    
    3) https://github.com/computationaltextiles/ct-buildpack-python-opencv.git
    
    4) https://github.com/oswellchan/heroku-buildpack-tesseract

    5) Ruby

For google compute engine:
      

rails s -p $PORT -b $IP
