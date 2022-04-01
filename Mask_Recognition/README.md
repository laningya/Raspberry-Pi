## 这是一个树莓派上关于戴口罩识别的项目
### 环境要求：
树莓派官方镜像并安装opencv4.5.0及以上版本（可能低版本可以跑此项目，但不做保证）<br>
连接摄像头并在树莓派系统开启摄像头驱动（如何开启自行百度，摄像头可以在某宝购买）
### mask.py 说明：
进入项目目录，输入命令：python3 mask.py 即可<br>
按ESC可以退出程序
### mask.led.py 说明：
安装python的树莓派GPIO库   sudo apt-get install python3-rpi.gpio <br>
这是对mask的升级改造，应用树莓派的GPIO接口，若检测对象未带口罩，则红色LED闪烁，若带了口罩，则绿色LED闪烁（红色LED接物理12、14引脚，绿色LED接物理16、14引脚，注意前正后负）<br>
进入项目目录，输入命令：python3 maskled.py 即可 <br>
按ESC可退出程序
