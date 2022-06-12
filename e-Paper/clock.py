import os
import epd2in7
import requests
import time
from PIL import Image,ImageDraw,ImageFont



epd = epd2in7.EPD()
font12 = ImageFont.truetype('./Font.ttc',12)
font24 = ImageFont.truetype('./Font.ttc',24)
font36 = ImageFont.truetype('./Font.ttc',36)

def init():
    epd.init()
    epd.Clear(0xFF)
    epd.sleep()

def clock():
    timeinfo = time.localtime()
    timeymd = time.strftime("%Y-%m-%d",timeinfo)
    timehm = time.strftime("%H:%M",timeinfo)
    times = time.strftime("%S",timeinfo)
    epd.init()
    image = Image.new('1', (epd.width, epd.height), 255)
    draw = ImageDraw.Draw(image)
    draw.text((20, 12), timeymd, font = font24, fill = 0)
    draw.text((20, 36), timehm, font = font36, fill = 0)
    image = image.transpose(Image.ROTATE_90) 
    epd.display(epd.getbuffer(image))
    epd.sleep()
    time.sleep(120-int(times))

def weather():
    url = 'https://devapi.qweather.com/v7/weather/now?location=101110509&key=bb6d9d9b301c40ac9ac69852710bfc1a'
    response = requests.get(url)
    weather_data = response.json()
    data = weather_data['now']
    epd.init()
    image = Image.new('1', (epd.width, epd.height), 255)
    draw = ImageDraw.Draw(image)
    draw.text((20, 12), '温度：'+ data['temp'] + '`C', font = font24, fill = 0)
    draw.text((20, 36), '天气：'+ data['text'], font = font24, fill = 0)
    image = image.transpose(Image.ROTATE_90) 
    epd.display(epd.getbuffer(image))
    epd.sleep()
    time.sleep(3600)

def raspberry_info():
    CPU_temperature = os.popen('vcgencmd measure_temp').readline().replace("temp=","").replace("'C\n","")
    tmp = os.popen('free -h')
    for i in range(0,2):
        info = tmp.readline()
    RAM_info = info.split()[1:4]
    CPU_use = os.popen("top -n1 | awk '/Cpu\(s\):/ {print $2}'").readline().strip()
    epd.init()
    image = Image.new('1', (epd.width, epd.height), 255)
    draw = ImageDraw.Draw(image)
    draw.text((20, 12), '温度：'+ CPU_temperature + '`C', font = font24, fill = 0)
    draw.text((20, 36), '内存：'+ RAM_info[2], font = font24, fill = 0)
    draw.text((20, 60), 'CPU：'+ CPU_use + '%', font = font24, fill = 0)
    image = image.transpose(Image.ROTATE_90) 
    epd.display(epd.getbuffer(image))
    epd.sleep()
    time.sleep(3600)

def test():
    epd.init()
    image = Image.new('1', (epd.width, epd.height), 255)
    draw = ImageDraw.Draw(image)
    draw.rectangle((176,0,166,10), fill = 0)
    image = image.transpose(Image.ROTATE_90) 
    epd.display(epd.getbuffer(image))
    epd.sleep()
    time.sleep(3600)



if __name__ == '__main__':
    while True:
        raspberry_info()
