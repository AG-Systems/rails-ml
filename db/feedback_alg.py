import sys
from PIL import Image, ImageStat
from colorthief import ColorThief
import tensorflow as tf
# from tesseract import image_to_string
import pytesser

results = ""
imgurl = str(sys.argv[1])
color_thief = ColorThief(imgurl)
rgb = color_thief.get_color(quality=1)
if rgb[0] > 150 and rgb[1] < 250 and rgb[2] < 50:
    results += "Warm Bright Colours: "
    if rgb[0] > 200:
        print "Bright colors are great for call to action. It may induce a sense of courage and energy. Its also eye catching"
    else:
        print "If you want more attention, use more red"
    if rgb[1] > 95 and rgb[1] < 160:
        print "Orange is fun version of red. Can be used for comfort."
    #results += "Remember to balance red. If overdone, it will create danger and negative reactions"
    if rgb[1] > 210 and rgb[1] < 255:
        print "Yellow is joy and optimism. Be careful not to use too much in your ad however as it can create fear and insecurity"

if rgb[0] < 200 and rgb[1] > 150 and rgb[2] < 100:
    print "Green has one of the most positive effect compared to other colors. Use this color to show health, rest, and to relieve stress"
if rgb[0] < 100 and rgb[1] > 100 and rgb[2] > 100:
    print "Blue is a really safe color. Its known for trust and reliabilty. Color blindess is also not affected by blue"


with Image.open(imgurl) as img:
    width, height = img.size
    if width <= 240 and height <= 240:
        print "Please increase image side"
    elif width == 300 and height == 250:
        print("Your ad is top performing ad size")
        print("Ad style: Medium Rectangle")
        print("Performs well when embedded within text content or at the end of articles.")
        print("Used for: Desktop")
    elif width == 336 and height == 280:
        print("Your ad is top performing ad size")
        print("Ad style: Large Rectangle")
        print("Performs well when embedded within text content or at the end of articles.")
        print("Used for: Desktop")
    elif width >= 500 and height <= 100:
        print("Your ad is top performing ad size")
        print("Ad style: Leaderboard")
        print("Performs well if placed above main content, and on forum sites.")
        print("Used for: Desktop")
    elif width == 300 and height == 600:
        print("Your ad is top performing ad size")
        print("Ad style: Half Page")
        print("Its currently really effective.")
        print("Used for: Desktop")
    elif width <= 320 and height == 100:
        print("Your ad is top performing ad size")
        print("Ad style: Large Mobile Banner")
        print("Top rated mobile ad")
        print("Used for: Mobile")
        
    elif width == 320 and height == 50:
        print("Ad style: Mobile Leaderboard")
        print("These ads have been shown to work well as a large smartphone ad format, particularly when used at the bottom of a page")
        print("Used for: Mobile")

    elif width >= 400 and height == 60 and width <= 499:
        print("Ad style: Banner")
        print("The supply of available display ads for this ad size is generally limited though, which may lead to sub-optimal ad performance.")
        print("Used for: Desktop")
        
txt = pytesser.image_to_string(imgurl)
txt = txt.replace('\n', ' ').replace('\r', '')
print("\n")
print("The amount of text on your ad is: " + str(len(txt)) + " characters")
print("\n")
print("Detected text: " + str(txt))

if len(txt) > 0:
    print("Remember: Facebook prefers little or no text on ad")