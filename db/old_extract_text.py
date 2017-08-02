import cv2
import sys
import os
from PIL import Image, ImageStat
import os.path

imgurl = str(sys.argv[1])
image = cv2.imread(imgurl)
with Image.open(imgurl) as img:
    width, height = img.size
gray = cv2.cvtColor(image,cv2.COLOR_BGR2GRAY) # grayscale
_,thresh = cv2.threshold(gray,150,255,cv2.THRESH_BINARY_INV) # threshold
kernel = cv2.getStructuringElement(cv2.MORPH_CROSS,(3,3))
dilated = cv2.dilate(thresh,kernel,iterations = 13) # dilate
_, contours, hierarchy = cv2.findContours(dilated,cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_NONE) # get contours
total_area = []
# for each contour found, draw a rectangle around it on original image
for contour in contours:
    # get rectangle bounding contour
    [x,y,w,h] = cv2.boundingRect(contour)
    print w,h
    # discard areas that are too large
    if h>300 and w>300:
        continue

    # discard areas that are too small
    if h<40 or w<40:
        continue
    print w,h
    total_area.append(float(w * h))
    print total_area
    # draw rectangle around contour on original image
    cv2.rectangle(image,(x,y),(x+w,y+h),(255,0,255),2)
print total_area
total = sum(total_area)
perc = (total / float(width * height)) * 100
# write original image with added contours to disk  
#cv2.imwrite("contoured.jpg", image) 
print perc