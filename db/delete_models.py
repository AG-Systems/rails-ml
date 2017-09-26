import os
from os.path import join
import sys

os.chdir('..')
os.remove("checkpoint")
files = os.listdir(os.curdir) 
for item in files:
    if item.endswith(".npy") or item.endswith(".csv") or item.endswith(".index") or item.endswith(".meta"):
        os.remove(item)
"""
os.remove("train_data.npy")

os.remove("posvsneg-0.001-6conv-basic.model.data-00000-of-00001")
os.remove("posvsneg-0.001-6conv-basic.model.index")
os.remove("posvsneg-0.001-6conv-basic.model.meta")
os.remove("submission_file.csv")
"""
print("SUCCESS")