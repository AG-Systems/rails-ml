import sys
from PIL import Image, ImageStat
from colorthief import ColorThief
import tensorflow as tf
# from tesseract import image_to_string
import pytesser
import string

results = ""
imgurl = str(sys.argv[1])
"""
color_thief = ColorThief(imgurl)
rgb = color_thief.get_color(quality=1)
if rgb[0] > 150 and rgb[1] < 250 and rgb[2] < 50:
    results += "Warm Bright Colours: "
    results += "\n"
    if rgb[0] > 200:
        results += "Bright colors are great for call to action. It may induce a sense of courage and energy. Its also eye catching"
    else:
        results += "If you want more attention, use more red"
    if rgb[1] > 95 and rgb[1] < 160:
        results += "Orange is fun version of red. Can be used for comfort."
    #results += "Remember to balance red. If overdone, it will create danger and negative reactions"
    if rgb[1] > 210 and rgb[1] < 255:
        results += "Yellow is joy and optimism. Be careful not to use too much in your ad however as it can create fear and insecurity"

if rgb[0] < 200 and rgb[1] > 150 and rgb[2] < 100:
    results += "Green has one of the most positive effect compared to other colors. Use this color to show health, rest, and to relieve stress"
if rgb[0] < 100 and rgb[1] > 100 and rgb[2] > 100:
    results += "Blue is a really safe color. Its known for trust and reliabilty. Color blindess is also not affected by blue"


with Image.open(imgurl) as img:
    width, height = img.size
    if width <= 240 and height <= 240:
        results += "Please increase image side"
    elif width == 300 and height == 250:
        results += "Your ad is top performing ad size"
        results += "\n"
        results += "Ad style: Medium Rectangle"
        results += "\n"
        results += "Performs well when embedded within text content or at the end of articles."
        results += "\n"
        results += "Used for: Desktop"
    elif width == 336 and height == 280:
        results += "Your ad is top performing ad size"
        results += "\n"
        results += "Ad style: Large Rectangle"
        results += "\n"
        results += "Performs well when embedded within text content or at the end of articles."
        results += "\n"
        results += "Used for: Desktop"
    elif width >= 500 and height <= 100:
        results += "Your ad is top performing ad size"
        results += "\n"
        results +="Ad style: Leaderboard"
        results += "Performs well if placed above main content, and on forum sites."
        results += "\n"
        results += "Used for: Desktop"
    elif width == 300 and height == 600:
        results += "Your ad is top performing ad size"
        results += "\n"
        results += "Ad style: Half Page"
        results += "\n"
        results += "Its currently really effective."
        results += "\n"
        results += "Used for: Desktop"
    elif width <= 320 and height == 100:
        results += "Your ad is top performing ad size"
        results += "\n"
        results += "Ad style: Large Mobile Banner"
        results += "\n"
        results += "Top rated mobile ad"
        results += "\n"
        results += "Used for: Mobile"
        
    elif width == 320 and height == 50:
        results += "Ad style: Mobile Leaderboard"
        results += "\n"
        results += "These ads have been shown to work well as a large smartphone ad format, particularly when used at the bottom of a page"
        results += "\n"
        results += "Used for: Mobile"

    elif width >= 400 and height == 60 and width <= 499:
        results += "Ad style: Banner"
        results += "\n"
        results += "The supply of available display ads for this ad size is generally limited though, which may lead to sub-optimal ad performance."
        results += "\n"
        results += "Used for: Desktop"
"""       
txt = pytesser.image_to_string(imgurl)
txt = txt.replace('\n', ' ').replace('\r', '')
alpha_list = list(string.ascii_lowercase)
length = 0
results += "\n"
for x in txt:
    if x in alpha_list:
        length += 1
print("\n")
if str(length) < 1:
    print("The amount of text on your ad is: " + str(length) + " characters")
    print("\n")
# print("Detected text: " + str(txt))
"""
if len(txt) > 5:
    results += "Remember: Facebook prefers little or no text on ad"
print(results)
"""