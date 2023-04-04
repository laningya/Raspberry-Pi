//https请求库
#include <ESP8266HTTPClient.h>
//json库
#include <ArduinoJson.h>
#include <WiFiClientSecureBearSSL.h>

class Weather
{
  public:
    //配置心知天气相关信息
    void config(String ,String ,String ,String);
    //获取天气信息
    void getData();
    //返回天气
    String getText();
    //返回温度
    String getTemperature();
    //返回日期
    String getDate();
  private:
    int getPayload();
    String _url;
    String _payload;
    String _text;
    String _temperature;
    String _date;
};
