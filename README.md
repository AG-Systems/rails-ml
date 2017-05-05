libs:

Python dependencies:


      Tensorflow

      Sklearn

      Pandas

      scipy

      pillow

      colorthief

      updated version of pip


Linux dependencies:


    tesseract-ocr



For heroku:

    heroku pg:reset DATABASE --app APP

    heroku run --app APP rake db:schema:load

    heroku run --app APP rake db:migrate

    heroku buildpacks:add https://github.com/oswellchan/heroku-buildpack-tesseract
    
    1) Python
    
    2) Custom buildpack

    3) Ruby
