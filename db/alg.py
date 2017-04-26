import sys
from PIL import Image
from colorthief import ColorThief

score = 0
calltoaction = ["start", "Stop","Build","Join","Learn","Discover","You", "Me", "My", "Want", "Need", "Free", "Save", "Try"]
imgurl = str(sys.argv[1])
color_thief = ColorThief(imgurl)
rgb = color_thief.get_color(quality=1)
if rgb[-1] > rgb[0] and rgb[-1] > rgb[1]:
    score += 5
    # blue is considered the most favorite color
print(score)