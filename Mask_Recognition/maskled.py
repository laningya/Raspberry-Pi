import cv2
import RPi.GPIO as GPIO
import time

face_engine = cv2.CascadeClassifier('haarcascade_frontalface_default.xml') # 导入人脸级联分类器，'.xml'文件里包含训练出来的人脸特征
mask_cascade = cv2.CascadeClassifier('cascade.xml') # 导入戴口罩级联分类器，'.xml'文件里包含训练出来的口罩特征

#相机参数设置
cap = cv2.VideoCapture(0)   # 调用摄像头摄像头
cap.set(3,640)   #摄像头窗口大小
cap.set(4,480)
font = cv2.FONT_HERSHEY_SIMPLEX  #字体
#初始化GPIO接口
GPIO.setmode(GPIO.BCM)
GPIO.setup(18,GPIO.OUT)
GPIO.setup(23,GPIO.OUT)

while(True):
    # 获取摄像头拍摄到的画面
    ret, img= cap.read()  # 读取一帧图像
    # 每帧图像放大1.3倍，重复检测5次
    faces = face_engine.detectMultiScale(img,1.3,5) 
    mask = mask_cascade.detectMultiScale(img,1.3,5)
    for (x,y,w,h) in faces:
        # 画出人脸框,红色，画笔宽度为1
        img = cv2.rectangle(img,(x,y),(x+w,y+h),(255,0,0),1)
        cv2.putText(img, 'no mask', (x, y - 5), font, 0.5, (255,0,0), 1)
        #LED显示红灯
        GPIO.output(18,GPIO.HIGH)
        time.sleep(0.5)
        GPIO.output(18,GPIO.LOW)
    for (ex,ey,ew,eh) in mask:
        #画出口罩框，绿色，画笔宽度为1
        cv2.rectangle(img,(int(ex),int(ey)),(int(ex+ew),int(ey+eh)),(0,255,0),1)
        cv2.putText(img, 'mask', (ex, ey - 5), font, 0.5, (0,255,0), 1)
        #LED显示绿灯
        GPIO.output(23,GPIO.HIGH)
        time.sleep(0.5)
        GPIO.output(23,GPIO.LOW)
    # 实时展示效果画面
    cv2.imshow('img',img)
    # 每100毫秒监听一次键盘动作,按ESC退出循环
    k = cv2.waitKey(100) & 0xff 
    if k == 27:
        break

# 最后，关闭所有窗口，释放资源
cap.release()
cv2.destroyAllWindows()
GPIO.cleanup()

