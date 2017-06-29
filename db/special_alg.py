import sys
import os
from PIL import Image, ImageStat
from colorthief import ColorThief
import tensorflow as tf
import pytesser
from colorthief import ColorThief

# NERUAL NET

import cv2
import numpy as np
import os
from random import shuffle
from tqdm import tqdm
import sys
import os.path

os.environ['TF_CPP_MIN_LOG_LEVEL']='2' # Disable Tensorflow debugging information

import tflearn
from tflearn.layers.conv import conv_2d, max_pool_2d
from tflearn.layers.core import input_data, dropout, fully_connected
from tflearn.layers.estimator import regression
import tensorflow as tf


import csv

img_c = str(sys.argv[3])
img_id = int(sys.argv[2])
img_name = str(sys.argv[1])

cater = ""
dataset = 0
if "car" in str(img_c):
    POS_FOLDER = os.path.abspath('db/algorithm/c_imgs/auto_good_ad')
    NEG_FOLDER = os.path.abspath('db/algorithm/c_imgs/auto_bad_ad')
    cater = "auto"
    dataset = 7
elif "site" in str(img_c):
    POS_FOLDER = os.path.abspath('db/algorithm/c_imgs/site_good_ad')
    NEG_FOLDER = os.path.abspath('db/algorithm/c_imgs/site_bad_ad')
    dataset = 0
    cater = "site"
elif "cheeseburger" in str(img_c):
    POS_FOLDER = os.path.abspath('db/algorithm/c_imgs/food_good_ad')
    NEG_FOLDER = os.path.abspath('db/algorithm/c_imgs/food_bad_ad')
    dataset = 0
    cater = "food"
else:
    POS_FOLDER = os.path.abspath('db/algorithm/train_imgs/positive')
    NEG_FOLDER = os.path.abspath('db/algorithm/train_imgs/negative')
    cater = "unknown"
    dataset = 0
#TEST_DIR = os.path.abspath('test_imgs')
TEST_DIR = os.path.abspath("public/uploads/" + str(img_id))
IMG_SIZE = 100
LR = 1e-3 

MODEL_NAME = 'posvsneg-{}-{}.model'.format(LR, '6conv-basic')

def create_train_data():
    training_data = []
    for img in os.listdir(POS_FOLDER):
        label = [1,0] #pos
        path = os.path.join(POS_FOLDER,img)
        img = cv2.resize(cv2.imread(path, cv2.IMREAD_GRAYSCALE), (IMG_SIZE,IMG_SIZE))
        training_data.append([np.array(img), np.array(label)])
    for img in os.listdir(NEG_FOLDER):
        label = [0,1] #neg
        path = os.path.join(NEG_FOLDER,img)
        img = cv2.resize(cv2.imread(path, cv2.IMREAD_GRAYSCALE), (IMG_SIZE,IMG_SIZE))
        training_data.append([np.array(img), np.array(label)])
    shuffle(training_data)
    np.save(cater + '_train_data.npy', training_data)
    return training_data
    

def process_test_data():
    testing_data = []
    for img in os.listdir(TEST_DIR):
        path = os.path.join(TEST_DIR,img)
        img_num = img.split('.')[0]
        img = cv2.resize(cv2.imread(path,cv2.IMREAD_GRAYSCALE), (IMG_SIZE,IMG_SIZE))
        testing_data.append([np.array(img), img_num])
    np.save(cater + '_test_data.npy', testing_data)
    return testing_data
        

train_data = create_train_data()
train_data = np.load(cater + '_train_data.npy')

# NERUAL NET

tf.reset_default_graph()
convnet = input_data(shape=[None, IMG_SIZE, IMG_SIZE, 1], name='input')

convnet = conv_2d(convnet, 32, 5, activation='relu')
convnet = max_pool_2d(convnet, 5)

convnet = conv_2d(convnet, 64, 5, activation='relu')
convnet = max_pool_2d(convnet, 5)

convnet = conv_2d(convnet, 128, 5, activation='relu')
convnet = max_pool_2d(convnet, 5)

convnet = conv_2d(convnet, 64, 5, activation='relu')
convnet = max_pool_2d(convnet, 5)

convnet = conv_2d(convnet, 32, 5, activation='relu')
convnet = max_pool_2d(convnet, 5)

convnet = fully_connected(convnet, 1024, activation='relu')
convnet = dropout(convnet, 0.8)

convnet = fully_connected(convnet, 2, activation='softmax')
convnet = regression(convnet, optimizer='adam', learning_rate=LR, loss='categorical_crossentropy', name='targets')

model = tflearn.DNN(convnet, tensorboard_dir='log')


model_exists = False
if os.path.exists('{}.meta'.format(MODEL_NAME)):
    model.load(MODEL_NAME)
    model_exists = True
    #print('model loaded!')
    pass


train = train_data[:-dataset]
test = train_data[-dataset:]

X = np.array([i[0] for i in train]).reshape(-1,IMG_SIZE,IMG_SIZE,1)
Y = [i[1] for i in train]

test_x = np.array([i[0] for i in test]).reshape(-1,IMG_SIZE,IMG_SIZE,1)
test_y = [i[1] for i in test]
if model_exists:
    model.fit({'input': X}, {'targets': Y}, n_epoch=10, validation_set=({'input': test_x}, {'targets': test_y}), 
        snapshot_step=500, show_metric=True, run_id=MODEL_NAME)
    
    model.save(MODEL_NAME)

# TESTING
test_data = process_test_data()
test_data = np.load(cater + '_test_data.npy')
image_file_name = os.path.basename(os.path.splitext(img_name)[0])
str_label = ""
print("RATING_CLASS")
for num,data in enumerate(test_data):
    # pos: [1,0]
    # neg: [0,1]
    
    img_num = data[1]
    img_data = data[0]
    orig = img_data
    data = img_data.reshape(IMG_SIZE,IMG_SIZE,1)
    #model_out = model.predict([data])[0]
    model_out = model.predict([data])[0]
    
    if str(image_file_name) == str(img_num):
        if np.argmax(model_out) == 1: 
            str_label='Do not run' #pos
        else: 
            str_label='Run' #neg
        print(str_label)

with open(cater + '_submission_file.csv','w') as f:
    f.write('id,label,test\n')
with open(cater + '_submission_file.csv','a') as f:
    for data in test_data:
        img_num = data[1]
        img_data = data[0]
        orig = img_data
        data = img_data.reshape(IMG_SIZE,IMG_SIZE,1)
        model_out = model.predict([data])[0]
        f.write('{},{}\n'.format(img_num,model_out[1]))
answer = 0
score = 5
print("RATING_SCORE")
with open(cater + '_submission_file.csv') as csvfile:
    readCSV = csv.reader(csvfile, delimiter=',')
    for row in readCSV:
        #print(row)
        #answer = str(round(float(row[1]), 2))
        if str(row[1]) != "label" and str(image_file_name) == row[0]:
            #answer = float("{0:.2f}".format(float(row[1])))
            #answer = float("{0:.2f}".format((float(row[1]) * 1.5)* 10))
            answer = float(row[1])
            answer *= 10
            if str_label == "Do not run":
                # answer = 10 - answer
                answer = -answer * .75
                pass
            else:
                answer = answer * .75
                pass
        #print(row[1])
        #print(row[0],row[1])
answer = float("{0:.2f}".format(answer))
score += answer
if score > 10:
    score = 10
if score < 0:
    score = 0
print(score)