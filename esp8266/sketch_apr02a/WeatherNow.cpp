#include "WeatherNow.h"

void WeatherNow::config(String key,String location,String language,String unit)
{
  _url = String("https://api.seniverse.com/v3/weather/now.json?key=") + key + String("&location=") + location + 
                  String("&language=") + language + String("&unit=") + unit;
  Serial.println(_url);
}

int WeatherNow::getPayload()
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
void WeatherNow::getData()
{
  if(WeatherNow::getPayload())
  {
    DynamicJsonDocument doc(4096);
    deserializeJson(doc, _payload);
    text = doc["results"][0]["now"]["text"].as<String>();
    Serial.println("text:" + text);
    temperature = doc["results"][0]["now"]["temperature"].as<String>();
    Serial.println("temperature:" + temperature);
    feels_like = doc["results"][0]["now"]["feels_like"].as<String>();
    Serial.println("feels_like:" + feels_like);
    pressure = doc["results"][0]["now"]["pressure"].as<String>();
    Serial.println("pressure:" + pressure);
    humidity = doc["results"][0]["now"]["humidity"].as<String>();
    Serial.println("humidity:" + humidity);
    visibility = doc["results"][0]["now"]["visibility"].as<String>();
    Serial.println("visibility:" + visibility);
    wind_direction = doc["results"][0]["now"]["wind_direction"].as<String>();
    Serial.println("wind_direction:" + wind_direction);
    wind_direction_degree = doc["results"][0]["now"]["wind_direction_degree"].as<String>();
    Serial.println("wind_direction_degree:" + wind_direction_degree);
    wind_speed = doc["results"][0]["now"]["wind_speed"].as<String>();
    Serial.println("wind_speed:" + wind_speed);
    wind_scale = doc["results"][0]["now"]["wind_scale"].as<String>();
    Serial.println("wind_scale:" + wind_scale);
    clouds = doc["results"][0]["now"]["clouds"].as<String>();
    Serial.println("clouds:" + clouds);
    dew_point = doc["results"][0]["now"]["dew_point"].as<String>();
    Serial.println("dew_point:" + dew_point);
    date = (doc["results"][0]["last_update"].as<String>()).substring(0,10);
    Serial.println("date:" + date);
  }
}

