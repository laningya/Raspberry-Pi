//wifi
#include <ESP8266WiFi.h>
//NTP服务
#include <NTPClient.h>
#include <WiFiUdp.h>
//oled1306驱动
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
//天气头文件
#include "WeatherNow.h"
#include "WeatherDay.h"
//设置串口速率
#define serialRate 115200
//设置WIFI名称与密码
#define ssid "***"
#define password "***"
//设置心知天气信息
#define key "***"
#define location "***"
#define language "en"
#define unit "c"

//初始化串口
void initSerial();
//初始化WiFi
void initWiFi();
//初始化Weather
void initWeather();
//初始化时间
void initTime();
//初始化屏幕
void initoled1306();

//设置屏幕显示位置与内容
void setDispaly(int size,int x,int y,String content);
//时间显示
void setTime();
//天气显示
void setWeather();
//位置显示
void setLocation();
//屏幕
Adafruit_SSD1306 oled(128, 64, &Wire,-1);
//时间
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP,"ntp1.aliyun.com",60*60*8, 30*60*1000);
//天气
WeatherNow a;
//计数
int counter = 0;

void setup(){
  initSerial();
  initWiFi();
  initWeather();
  initTime();
  initOled1306();
}
void loop() {
  Serial.println("...");
  setTime();
  setWeather(counter);
  setLocation();
  oled.display(); // 开显示
  delay(1000);
  oled.clearDisplay();//清屏
  counter += 1;
  if(counter >= 60)
  counter = 0;
}
void initSerial()
{
  Serial.begin(serialRate);
  Serial.println(".");
}
void initWiFi()
{
  WiFi.setAutoReconnect(true);
  WiFi.begin(ssid, password);
  while ( WiFi.status() != WL_CONNECTED ) {
    Serial.print("Connecting ");
    Serial.println(ssid);
    delay ( 500 );
  }
  Serial.println(WiFi.localIP());
}
void initWeather()
{
  a.config(String(key),String(location),String(language),String(unit));
}
void initTime()
{
  timeClient.begin();
}
void initOled1306()
{
  oled.begin(SSD1306_SWITCHCAPVCC,0x3C);
  oled.setTextColor(WHITE);//开像素点发光
  oled.clearDisplay();//清屏
}
void setDispaly(int size,int x,int y,String content)
{
  oled.setTextSize(size);//设置字体大小  
  oled.setCursor(x,y);//设置显示位置
  oled.println(content);
}
void setTime()
{
  timeClient.update();
  Serial.println(timeClient.getFormattedTime());
  setDispaly(2,20,45,timeClient.getFormattedTime());
}
void setWeather(int counter)
{
  if(counter == 0)
  {
    a.getData();
    setDispaly(1,55,5,a.text);
    setDispaly(1,110,5,a.temperature);
    setDispaly(1,35,30,a.date);
  }
  else
  {
    setDispaly(1,55,5,a.text);
    setDispaly(1,110,5,a.temperature);
    setDispaly(1,35,30,a.date);
  }
}
void setLocation()
{
  setDispaly(1,5,5,String(location));
}
