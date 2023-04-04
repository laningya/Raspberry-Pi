#include <NTPClient.h>
// change next line to use with another board/shield
#include <ESP8266WiFi.h>
//#include <WiFi.h> // for WiFi shield
//#include <WiFi101.h> // for WiFi 101 shield or MKR1000
#include <WiFiUdp.h>
//
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>


const char *ssid     = "TP-LINK";
const char *password = "12345678";

char daysOfTheWeek[7][12] = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};

WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP,"ntp1.aliyun.com",60*60*8, 30*60*1000);
//
Adafruit_SSD1306 oled(128, 64, &Wire,-1);
void setup(){
  Serial.begin(115200);

  WiFi.begin(ssid, password);

  while ( WiFi.status() != WL_CONNECTED ) {
    delay ( 500 );
    Serial.print (WiFi.localIP());
  }

  timeClient.begin();
  //
  oled.begin(SSD1306_SWITCHCAPVCC,0x3C);
  oled.setTextColor(WHITE);//开像素点发光
  oled.clearDisplay();//清屏
}

void loop() {
  timeClient.update();

  Serial.println(timeClient.getFormattedTime());
  Serial.println(daysOfTheWeek[timeClient.getDay()]);
  //
  oled.setTextSize(2);//设置字体大小  
  oled.setCursor(15, 30);//设置显示位置
  oled.println(timeClient.getFormattedTime());
  oled.display(); // 开显示
  
  delay(1000);
  oled.clearDisplay();//清屏
}
