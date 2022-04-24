#! /usr/bin/python
import requests


url = 'https://devapi.qweather.com/v7/weather/now?location=101110509&key=bb6d9d9b301c40ac9ac69852710bfc1a'
response = requests.get(url)
weather_data = response.json()
print(weather_data['now'])