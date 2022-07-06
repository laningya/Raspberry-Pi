#微雪墨水屏Python程序

import os
import epd2in7
import time
import requests
from PIL import Image,ImageDraw,ImageFont


class Ink_display(object):
    def __init__(self):
        self.epd = epd2in7.EPD()
        self.epd.init()
        self.epd.Clear(0xFF)
        self.font12 = ImageFont.truetype('./Font.ttc',12)
        self.font24 = ImageFont.truetype('./Font.ttc',24)
        self.font36 = ImageFont.truetype('./Font.ttc',36)

    def clock(self):
        timeinfo = time.localtime()
        timeymd = time.strftime("%Y-%m-%d",timeinfo)
        timehm = time.strftime("%H:%M",timeinfo)
        times = time.strftime("%S",timeinfo)
        image = Image.new('1', (self.epd.width, self.epd.height), 255)
        draw = ImageDraw.Draw(image)
        draw.text((20, 12), timeymd, font = self.font24, fill = 0)
        draw.text((20, 36), timehm, font = self.font36, fill = 0)
        self.epd.display(self.epd.getbuffer(image))
        
    def weather(self):
        url = 'https://devapi.qweather.com/v7/weather/now?location=101110509&key=bb6d9d9b301c40ac9ac69852710bfc1a'
        response = requests.get(url)
        weather_data = response.json()
        data = weather_data['now']
        image = Image.new('1', (self.epd.width, self.epd.height), 255)
        draw = ImageDraw.Draw(image)
        draw.text((20, 12), '温度:' + data['temp']+ '`C', font = self.font24, fill = 0)
        draw.text((20, 36), '天气:' + data['text'], font = self.font24, fill = 0)
        self.epd.display(self.epd.getbuffer(image))

    def raspberry_info(self):
        CPU_temperature = os.popen('vcgencmd measure_temp').readline().replace("temp=","").replace("'C\n","")
        tmp = os.popen('free -h')
        for i in range(0,2):
            info = tmp.readline()
        RAM_info = info.split()[1:4]
        CPU_use = os.popen("top -n1 | awk '/Cpu\(s\):/ {print $2}'").readline().strip()
        image = Image.new('1', (self.epd.width, self.epd.height), 255)
        draw = ImageDraw.Draw(image)
        draw.text((20, 12), '温度：'+ CPU_temperature + '`C', font = self.font24, fill = 0)
        draw.text((20, 36), '内存：'+ RAM_info[2], font = self.font24, fill = 0)
        draw.text((20, 60), 'CPU：'+ CPU_use + '%', font = self.font24, fill = 0)
        self.epd.display(self.epd.getbuffer(image))

ink_display = Ink_display()
ink_display.raspberry_info()

