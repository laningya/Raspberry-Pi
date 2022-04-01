import cv2
import os

#开启摄像头
cam = cv2.VideoCapture(0)
#初始化窗口大小
cam.set(3, 640) 
cam.set(4, 480) 

#加载级联分类器
face_detector = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')

#输入用户ID
face_id = input('\n enter user id end press <return> ==>  ')

print("\n [INFO] Initializing face capture. Look the camera and wait ...")
count = 0

#循环采样人脸照片并保存
while(True):

    #读取照片
    ret, img = cam.read()
    #转化为灰度图
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    #定位人脸坐标
    faces = face_detector.detectMultiScale(gray, 1.3, 5)
    
    for (x,y,w,h) in faces:

        #标记人脸位置
        cv2.rectangle(img, (x,y), (x+w,y+h), (255,0,0), 2)     
        count += 1
        #保存人脸到dataset数据集下
        cv2.imwrite("dataset/User." + str(face_id) + '.' + str(count) + ".jpg", gray[y:y+h,x:x+w])
        #显示人脸照片，提高交互性
        cv2.imshow('image', img)
    #按ESC键随时退出程序
    k = cv2.waitKey(100) & 0xff 
    if k == 27:
        break
    elif count >= 30: 
         break

#释放摄像头资源
print("\n [INFO] Exiting Program and cleanup stuff")
cam.release()
cv2.destroyAllWindows()
