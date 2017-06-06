import sys
from PIL import Image, ImageStat
from colorthief import ColorThief
import tensorflow as tf
# from tesseract import image_to_string
import pytesser
import string

results = ""
imgurl = str(sys.argv[1])


txt = pytesser.image_to_string(str(sys.argv[1]))
txt = txt.replace('\n', ' ').replace('\r', '')
# obj_results = os.system("python db/classify_image.py" + " " + TEST_DIR + "/" + img_name)
calltoaction = ["start", "stop","build","join","learn","discover","you", "me", "my", "want", "need", "free", "save", "try", "you"]
if str_label == "Do not run":
    if len(txt) > 50:
        print("You have too much text on your ad")
    if detect_color_image(img_name) == -1:
        print("Your ad colours are hard to tell by an computer")
    pass
else:
    if len(txt) > 10:
        txt = txt.split()
        temp = 0
        for x in txt:
            if x.lower() in calltoaction:
                temp += 1
        if temp == 0:
            print("If you choose to use text within your ad, it would be beneficial to utilize a call to action word or phrase.")
        
    pass
