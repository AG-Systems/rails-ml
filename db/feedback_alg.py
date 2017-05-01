import sys
from PIL import Image, ImageStat
from colorthief import ColorThief
import tensorflow as tf

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