import os
import sys
import logging
import epd2in7
import requests
import time
from PIL import Image,ImageDraw,ImageFont

'''
url = 'https://devapi.qweather.com/v7/weather/now?location=101110509&key=bb6d9d9b301c40ac9ac69852710bfc1a'
response = requests.get(url)
weather_data = response.json()
data = weather_data['now']
'''
epd = epd2in7.EPD()
epd.init()
epd.Clear(0xFF)
font24 = ImageFont.truetype('/home/pi/Raspberry-Pi/e-Paper/Font.ttc',24)
font36 = ImageFont.truetype('/home/pi/Raspberry-Pi/e-Paper/Font.ttc',36)

def init():
    epd.init()
    epd.Clear(0xFF)
    epd.sleep()

def clock():
    epd.init()
    timeinfo = time.localtime()
    timeymd = time.strftime("%Y-%m-%d",timeinfo)
    timehm = time.strftime("%H:%M",timeinfo)
    times = time.strftime("%S",timeinfo)
    image = Image.new('1', (epd.width, epd.height), 255)
    draw = ImageDraw.Draw(image)
    draw.text((20, 12), timeymd, font = font24, fill = 0)
    draw.text((20, 36), timehm, font = font36, fill = 0)
    image = image.transpose(Image.ROTATE_180)
    epd.display(epd.getbuffer(image))
    epd.sleep()
    time.sleep(120-int(times))

if __name__ == '__main__':
    init()
    while True:
        clock()
