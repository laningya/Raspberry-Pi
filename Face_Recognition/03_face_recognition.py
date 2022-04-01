import cv2
import numpy as np
import os 

#加载LBPH以及训练模型
recognizer = cv2.face.LBPHFaceRecognizer_create()
recognizer.read('trainer/trainer.yml')
#加载级联分类器
cascadePath = "haarcascade_frontalface_default.xml"
faceCascade = cv2.CascadeClassifier(cascadePath);

#设置字体
font = cv2.FONT_HERSHEY_SIMPLEX

id = 0

#识别对象的名称
names = ['mln','szs', 'gzl', 'teacher', 'Z', 'W'] 

#启动摄像头
cam = cv2.VideoCapture(0)
#初始化摄像头窗口大小
cam.set(3, 640) 
cam.set(4, 480) 

#设置最小被识别面部窗口大小
minW = 0.1*cam.get(3)
minH = 0.1*cam.get(4)

while True:

    #读取一张图片
    ret, img =cam.read()

    #转化为灰度图
    gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)

    #得到人脸在图片中的坐标
    faces = faceCascade.detectMultiScale( 
        gray,
        scaleFactor = 1.2,
        minNeighbors = 5,
        minSize = (int(minW), int(minH)),
       )
    
    for(x,y,w,h) in faces:

        #标记人脸位置
        cv2.rectangle(img, (x,y), (x+w,y+h), (0,255,0), 2)
        
        #对人脸进行比对检测
        id, confidence = recognizer.predict(gray[y:y+h,x:x+w])

        #输出把握
        if (confidence < 100):
            id = names[id]
            confidence = "  {0}%".format(round(100 - confidence))
        else:
            id = "unknown"
            confidence = "  {0}%".format(round(100 - confidence))
        
        cv2.putText(img, str(id), (x+5,y-5), font, 1, (255,255,255), 2)
        cv2.putText(img, str(confidence), (x+5,y+h-5), font, 1, (255,255,0), 1)  
   
    #显示出被处理后的图片
    cv2.imshow('camera',img) 

    #按ESC可随时退出程序
    k = cv2.waitKey(10) & 0xff 
    if k == 27:
        break

#释放摄像头资源
print("\n [INFO] Exiting Program and cleanup stuff")
cam.release()
cv2.destroyAllWindows()
