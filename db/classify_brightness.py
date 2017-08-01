import sys
import os.path
from PIL import Image, ImageStat
import os

def brightness( im_file ):
   im = Image.open(im_file).convert('L')
   stat = ImageStat.Stat(im)
   return stat.mean[0]
imgurl = str(sys.argv[1])

print brightness(imgurl)