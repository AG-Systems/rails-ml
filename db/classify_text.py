import sys
import os.path
import pytesser

imgurl = str(sys.argv[1])
txt = pytesser.image_to_string(imgurl)

print txt