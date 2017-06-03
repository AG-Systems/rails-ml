import os

os.chdir('..')
os.remove("train_data.npy")
os.remove("checkpoint")
os.remove("posvsneg-0.001-6conv-basic.model.data-00000-of-00001")
os.remove("posvsneg-0.001-6conv-basic.model.index")
os.remove("posvsneg-0.001-6conv-basic.model.meta")
os.remove("submission_file.csv")
print("SUCCESS")