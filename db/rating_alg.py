import sys
import os
from PIL import Image, ImageStat
from colorthief import ColorThief
import tensorflow as tf

score = 0

def detect_color_image(file, thumb_size=40, MSE_cutoff=22, adjust_color_bias=True):
    color_score = 0
    pil_img = Image.open(file)
    bands = pil_img.getbands()
    if bands == ('R','G','B') or bands== ('R','G','B','A'):
        thumb = pil_img.resize((thumb_size,thumb_size))
        SSE, bias = 0, [0,0,0]
        if adjust_color_bias:
            bias = ImageStat.Stat(thumb).mean[:3]
            bias = [b - sum(bias)/3 for b in bias ]
        for pixel in thumb.getdata():
            mu = sum(pixel)/3
            SSE += sum((pixel[i] - mu - bias[i])*(pixel[i] - mu - bias[i]) for i in [0,1,2])
        MSE = float(SSE)/(thumb_size*thumb_size)
        if MSE <= MSE_cutoff:
            print "grayscale\t",
        else:
            color_score += 2
            #print "Color\t\t\t",
        #print "( MSE=",MSE,")"
    elif len(bands)==1:
        # print "Black and white", bands
        color_score += 1
    else:
        #print "Don't know...", bands
        color_score -= 1
    return color_score

calltoaction = ["start", "Stop","Build","Join","Learn","Discover","You", "Me", "My", "Want", "Need", "Free", "Save", "Try"]
imgurl = str(sys.argv[1])
score += detect_color_image(imgurl)
color_thief = ColorThief(imgurl)
rgb = color_thief.get_color(quality=1)
print(score)


# Blacks most common association is power, authority and strength
# White is directly linked to that which is righteous, good and peaceful 