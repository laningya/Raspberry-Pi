#include <ArduinoJson.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClientSecureBearSSL.h>

class WeatherNow
{
  public:
    //配置心知天气相关信息
    void config(String ,String ,String ,String);
    //获取天气信息
    void getData();
  public:
    //天气
    String text;
    //温度
    String temperature;
    //体感温度
    String feels_like;
    //气压
    String pressure;
    //相对湿度
    String humidity;
    //能见度
    String visibility;
    //风向
    String wind_direction;
    //风向角度
    String wind_direction_degree;
    //风速
    String wind_speed;
    //风力等级
    String wind_scale;
    //云量
    String clouds;
    //露点温度
    String dew_point;
    //日期
    String date;
  private:
    int getPayload();
    String _url;
    String _payload;

};
