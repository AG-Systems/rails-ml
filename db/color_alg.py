import sys
from PIL import Image, ImageStat
from colorthief import ColorThief
import cv2
import tensorflow as tf
# from tesseract import image_to_string
import random
import numpy
import pytesser
import string
import os
from difflib import SequenceMatcher
import sys
import os.path


imgurl = str(sys.argv[1])
attention_score = 0

color_thief = ColorThief(imgurl)

def brightness( im_file ):
   im = Image.open(im_file).convert('L')
   stat = ImageStat.Stat(im)
   return stat.mean[0]

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
            #print "grayscale\t",
            pass
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
    
color_results = detect_color_image(imgurl)
if color_results == 2:
    attention_score += 1.0
elif color_results == 1:
    attention_score += .5
color_results = brightness(imgurl)
if color_results > 100:
    attention_score += 1.0
elif color_results > 50:
    attention_score += 1.5
dominant_color = color_thief.get_color(quality=1)
palette = color_thief.get_palette(color_count=10)

txt = pytesser.image_to_string(str(sys.argv[1]))
txt = txt.lower()
txt = txt.replace('\n', ' ').replace('\r', '')
callnum = 0
calltoaction = ["start", "stop","build","join","learn","discover","you", "me", "my", "want", "need", "free", "save", "try", "you"]
for x in txt:
    for y in calltoaction:
        if y in x:
            callnum += 1
callnum = callnum * 1.5

attention_score += callnum
attention_score = "%.1f" % attention_score


print(attention_score) #ATTENTION GRAB