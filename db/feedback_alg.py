import sys
from PIL import Image, ImageStat
from colorthief import ColorThief
from collections import Counter
# from tesseract import image_to_string
import pytesser
import string
import numpy as np
import math 

results = ""
imgurl = str(sys.argv[1])

counter = 0
txt = pytesser.image_to_string(str(sys.argv[1]))
txt = txt.lower()
txt = txt.replace('\n', ' ').replace('\r', '')

def getUniquePixelValuesByChannel(imagePath, hexBase=True):
    '''
    returns lists of unique pixel value for each channel in image(r,g,b,a)
    '''
    image = Image.open(imagePath)
    histogram = image.histogram()
    channels = [histogram[p : p + 256] for p in range(0, len(histogram), 256)]
    unique_pixels = []
    for c in channels:
        unique_pixels.append([hexBase and hex(p) or p for p in range(len(c)) if c[p] > 0])
    return unique_pixels
#img = Image.open(imgurl)
unique_pixels = getUniquePixelValuesByChannel(imgurl, hexBase=True)

red = (len(unique_pixels[0]) / 256) * 100
green = (len(unique_pixels[1]) / 256) * 100
blue = (len(unique_pixels[2]) / 256) * 100
# alpha = (len(unique_pixels[3]) / 256) * 100
total_score = abs(red - green - blue)
min_score =  min(red,green,blue)
max_score = max(red,green,blue)
if max_score - min_score > 150:
    counter += 2.5
elif max_score - min_score > 125:
    counter += 2.0
elif max_score - min_score > 100:
    counter += 1.5
elif max_score - min_score > 75:
    counter += 1.0
elif max_score - min_score > 50:
    counter += .5
else:
    counter += .25
counter *= 1.5

#counter += (total_score * .10)
# print(unique_pixels)
print(counter)