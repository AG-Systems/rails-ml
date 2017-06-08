import sys
from PIL import Image, ImageStat
from colorthief import ColorThief
import tensorflow as tf
# from tesseract import image_to_string
import pytesser
import string

results = ""
imgurl = str(sys.argv[1])

counter = 0
txt = pytesser.image_to_string(str(sys.argv[1]))
txt = txt.lower()
txt = txt.replace('\n', ' ').replace('\r', '')
# obj_results = os.system("python db/classify_image.py" + " " + TEST_DIR + "/" + img_name)
calltoaction = ["start", "stop","build","join","learn","discover","you", "me", "my", "want", "need", "free", "save", "try", "you"]
for x in txt:
    for y in calltoaction:
        if y in x:
            if counter > 2.5:
                counter += .5
            else:
                counter += 1.5
print(counter)