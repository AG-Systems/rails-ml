import sys
from PIL import Image, ImageStat
from colorthief import ColorThief
from collections import Counter
# from tesseract import image_to_string
import pytesser
import string
import numpy as np
import math 
import os 
from difflib import SequenceMatcher

results = ""
imgurl = str(sys.argv[1])

counter = 0

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
def similar(a, b):
    return SequenceMatcher(None, a, b).ratio()

def dhash(image, hash_size = 8):
    # Grayscale and shrink the image in one step.
    image = image.convert('L').resize(
        (hash_size + 1, hash_size),
        Image.ANTIALIAS,
    )

    pixels = list(image.getdata())

    # Compare adjacent pixels.
    difference = []
    for row in xrange(hash_size):
        for col in xrange(hash_size):
            pixel_left = image.getpixel((col, row))
            pixel_right = image.getpixel((col + 1, row))
            difference.append(pixel_left > pixel_right)

    # Convert the binary array to a hexadecimal string.
    decimal_value = 0
    hex_string = []
    for index, value in enumerate(difference):
        if value:
            decimal_value += 2**(index % 8)
        if (index % 8) == 7:
            hex_string.append(hex(decimal_value)[2:].rjust(2, '0'))
            decimal_value = 0
    return ''.join(hex_string)
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
#counter *= 1.5
image_test = dhash(Image.open(imgurl))

POS_FOLDER = os.path.abspath('db/algorithm/train_imgs/positive')
NEG_FOLDER = os.path.abspath('db/algorithm/train_imgs/negative')

for img in os.listdir(POS_FOLDER):
    #y = Image.open(img)
    y = Image.open(os.path.abspath('db/algorithm/train_imgs/positive/' + img))
    x = dhash(y)
    if image_test == x:
        counter += 0.10
    else:
        temp_score = similar(img,x)
        if temp_score < 0.1:
            counter += 0.010
for img in os.listdir(NEG_FOLDER):
    y = Image.open(os.path.abspath('db/algorithm/train_imgs/negative/' + img))
    x = dhash(y)
    if image_test == x:
        counter += 0.10
    else:
        temp_score = similar(img,x)
        if temp_score < 0.1:
            counter += 0.010
#counter += (total_score * .10)
# print(unique_pixels)
if counter > 10.0:
    counter = 10.0
elif counter < 0.0:
    counter = 0
counter = "%.1f" % counter
print(counter)   #MEMEBOLITY