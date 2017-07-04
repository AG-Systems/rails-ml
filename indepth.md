## 0) Install ruby, python, rails

    Ruby version: 2.3.4
    
    Rails version: 5.0.0
    
    Python: 2.7.6, preferred python 3.X
    
    sudo easy_install pip (if pip is not installed)
    
    sudo apt-get install libpq-dev (for PG db)

## 1) Clone the project

`git clone https://github.com/AG-Systems/rails-ml.git`

## 2) Install the ruby libaries

`bundle install`

## 3) Install the python libaries 

`pip install -r requirements.txt`

## 4) Install the linux dependencies

`sudo apt-get install tesseract-ocr`

`sudo apt-get install imagemagick`

`sudo apt-get install libmagickwand-dev`

## 5) Setup databse

`rake db:schema:load`

`rake db:migrate`

## 6) Run your project

if you are on cloud9

`rails s -p $PORT -b $IP`

Local machine: 

`rails s`
