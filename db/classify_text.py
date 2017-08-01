import sys
import os.path
from PIL import Image
import os
import cv2
import pytesser

imgurl = str(sys.argv[1])
txt = pytesser.image_to_string(imgurl)

print txt