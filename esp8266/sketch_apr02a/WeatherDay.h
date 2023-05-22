#include <ArduinoJson.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClientSecureBearSSL.h>

class WeatherDay
{
  public:
    void config(String ,String ,String ,String);
    void getData();
  public:
    String date0;
    String date1;
    String date2;
    String text_day0;
    String text_day1;
    String text_day2;
    String text_night0;
    String text_night1;
    String text_night2;
    String code_night0;
    String code_night1;
    String code_night2;
    String high0;
    String high1;
    String high2;
    String low0;
    String low1;
    String low2;
    String precip0; 
    String precip1; 
    String precip2; 
    String wind_direction0;
    String wind_direction1;
    String wind_direction2;
    String wind_direction_degree0;
    String wind_direction_degree1;
    String wind_direction_degree2;
    String wind_speed0;
    String wind_speed1;
    String wind_speed2;
    String wind_scale0;
    String wind_scale1;
    String wind_scale2;
    String rainfall0;
    String rainfall1;
    String rainfall2;
    String humidity0;
    String humidity1;
    String humidity2;
  private:
    int getPayload();
    String _url;
    String _payload;

};
