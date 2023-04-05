#include "WeatherDay.h"

void WeatherDay::config(String key,String location,String language,String unit)
{
  _url = String("https://api.seniverse.com/v3/weather/daily.json?key=") + key + String("&location=") + location + 
                  String("&language=") + language + String("&unit=") + unit + String("&start=0&days=3");
  Serial.println(_url);
}

int WeatherDay::getPayload()
{
  std::unique_ptr<BearSSL::WiFiClientSecure> client(new BearSSL::WiFiClientSecure);
  client->setInsecure();
  HTTPClient https;

  if(https.begin(*client,_url))
  {
    Serial.print("[HTTPS] GET...\n");
    int httpCode = https.GET();
    if(httpCode > 0)
    {
      Serial.printf("HTTPS GET... code: %d\n",httpCode);
      if(httpCode ==HTTP_CODE_OK || httpCode == HTTP_CODE_MOVED_PERMANENTLY) 
      {
        _payload = https.getString();
        Serial.println(_payload);
        return 1;
      } 
    }
    else
    {
      Serial.printf("[HTTPS] GET... failed, error: %s\n", https.errorToString(httpCode).c_str()); 
      return 0; 
    }
    https.end();
  }
  else
  {
    Serial.printf("[HTTPS] Unable to connect\n");
  }
  return 0;
}

void WeatherDay::getData()
{
  if(WeatherDay::getPayload())
  {
    DynamicJsonDocument doc(4096);
    deserializeJson(doc, _payload);
    date0 = (doc["results"][0]["daily"][0]["date"].as<String>()).substring(5,10);
    Serial.println("date0:" + date0);
    date1 = (doc["results"][0]["daily"][1]["date"].as<String>()).substring(5,10);
    Serial.println("date1:" + date1);
    date2 = (doc["results"][0]["daily"][2]["date"].as<String>()).substring(5,10);
    Serial.println("date2:" + date2);
    text_day0 = doc["results"][0]["daily"][0]["text_day"].as<String>();
    Serial.println("text_day0:" + text_day0);
    text_day1 = doc["results"][0]["daily"][1]["text_day"].as<String>();
    Serial.println("text_day1:" + text_day1);
    text_day2 = doc["results"][0]["daily"][2]["text_day"].as<String>();
    Serial.println("text_day2:" + text_day2);
    text_night0 = doc["results"][0]["daily"][0]["text_night"].as<String>();
    Serial.println("text_night0:" + text_night0);
    text_night1 = doc["results"][0]["daily"][1]["text_night"].as<String>();
    Serial.println("text_night1:" + text_night1);
    text_night2 = doc["results"][0]["daily"][2]["text_night"].as<String>();
    Serial.println("text_night2:" + text_night2);
    code_night0 = doc["results"][0]["daily"][0]["code_night"].as<String>();
    Serial.println("code_night0:" + code_night0);
    code_night1 = doc["results"][0]["daily"][1]["code_night"].as<String>();
    Serial.println("code_night1:" + code_night1);
    code_night2 = doc["results"][0]["daily"][2]["code_night"].as<String>();
    Serial.println("code_night2:" + code_night2);
    high0 = doc["results"][0]["daily"][0]["high"].as<String>();
    Serial.println("high0:" + high0);
    high1 = doc["results"][0]["daily"][1]["high"].as<String>();
    Serial.println("high1:" + high1);
    high2 = doc["results"][0]["daily"][2]["high"].as<String>();
    Serial.println("high2:" + high2);
    low0 = doc["results"][0]["daily"][0]["low"].as<String>();
    Serial.println("low0:" + low0);
    low1 = doc["results"][0]["daily"][1]["low"].as<String>();
    Serial.println("low1:" + low1);
    low2 = doc["results"][0]["daily"][2]["low"].as<String>();
    Serial.println("low2:" + low2);
    precip0 = doc["results"][0]["daily"][0]["precip"].as<String>();
    Serial.println("precip0:" + precip0);
    precip1 = doc["results"][0]["daily"][1]["precip"].as<String>();
    Serial.println("precip1:" + precip1);
    precip2 = doc["results"][0]["daily"][2]["precip"].as<String>();
    Serial.println("precip2:" + precip2);
    wind_direction0 = doc["results"][0]["daily"][0]["wind_direction"].as<String>();
    Serial.println("wind_direction0:" + wind_direction0);
    wind_direction1 = doc["results"][0]["daily"][1]["wind_direction"].as<String>();
    Serial.println("wind_direction1:" + wind_direction1);
    wind_direction2 = doc["results"][0]["daily"][2]["wind_direction"].as<String>();
    Serial.println("wind_direction2:" + wind_direction2);
    wind_direction_degree0 = doc["results"][0]["daily"][0]["wind_direction_degree"].as<String>();
    Serial.println("wind_direction_degree0:" + wind_direction_degree0);
    wind_direction_degree1 = doc["results"][0]["daily"][1]["wind_direction_degree"].as<String>();
    Serial.println("wind_direction_degree1:" + wind_direction_degree1);
    wind_direction_degree2 = doc["results"][0]["daily"][2]["wind_direction_degree"].as<String>();
    Serial.println("wind_direction_degree2:" + wind_direction_degree2);
    wind_speed0 = doc["results"][0]["daily"][0]["wind_speed"].as<String>();
    Serial.println("wind_speed0:" + wind_speed0);
    wind_speed1 = doc["results"][0]["daily"][1]["wind_speed"].as<String>();
    Serial.println("wind_speed1:" + wind_speed1);
    wind_speed2 = doc["results"][0]["daily"][2]["wind_speed"].as<String>();
    Serial.println("wind_speed2:" + wind_speed2);
    wind_scale0 = doc["results"][0]["daily"][0]["wind_scale"].as<String>();
    Serial.println("wind_scale0:" + wind_scale0);
    wind_scale1 = doc["results"][0]["daily"][1]["wind_scale"].as<String>();
    Serial.println("wind_scale1:" + wind_scale1);
    wind_scale2 = doc["results"][0]["daily"][2]["wind_scale"].as<String>();
    Serial.println("wind_scale2:" + wind_scale2);
    rainfall0 = doc["results"][0]["daily"][0]["rainfall"].as<String>();
    Serial.println("rainfall0:" + rainfall0);
    rainfall1 = doc["results"][0]["daily"][1]["rainfall"].as<String>();
    Serial.println("rainfall1:" + rainfall1);
    rainfall2 = doc["results"][0]["daily"][2]["rainfall"].as<String>();
    Serial.println("rainfall2:" + rainfall2);
    humidity0 = doc["results"][0]["daily"][0]["humidity"].as<String>();
    Serial.println("humidity0:" + humidity0);
    humidity1 = doc["results"][0]["daily"][1]["humidity"].as<String>();
    Serial.println("humidity1:" + humidity1);
    humidity2 = doc["results"][0]["daily"][2]["humidity"].as<String>();
    Serial.println("humidity2:" + humidity2);
  }
}
