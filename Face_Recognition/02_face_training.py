import cv2
import numpy as np
from PIL import Image
import os

path = 'dataset'

#加载LBPH及级联分类器
recognizer = cv2.face.LBPHFaceRecognizer_create()
detector = cv2.CascadeClassifier("haarcascade_frontalface_default.xml");

def getImagesAndLabels(path):

    #加载dataset数据集下的人脸照片
    imagePaths = [os.path.join(path,f) for f in os.listdir(path)]     
    faceSamples=[]
    ids = []

    for imagePath in imagePaths:
        
        #灰度图形式打开图片
        PIL_img = Image.open(imagePath).convert('L') 
        #返回图片灰度的数组
        img_numpy = np.array(PIL_img,'uint8')

        #通过字符串切片操作抓取图片ID
        id = int(os.path.split(imagePath)[-1].split(".")[1])
        #确定人脸在图片中的位置坐标
        faces = detector.detectMultiScale(img_numpy)
        #人脸矩形框灰度存储在faceSamples中
        for (x,y,w,h) in faces:
            faceSamples.append(img_numpy[y:y+h,x:x+w])
            ids.append(id)

    return faceSamples,ids

print ("\n [INFO] Training faces. It will take a few seconds. Wait ...")
faces,ids = getImagesAndLabels(path)
#通过LBPH训练模型，得到LBP特征
recognizer.train(faces, np.array(ids))

#存储训练结果到trainer目录下
recognizer.write('trainer/trainer.yml') 

print("\n [INFO] {0} faces trained. Exiting Program".format(len(np.unique(ids))))
