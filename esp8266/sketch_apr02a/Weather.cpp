#include "Weather.h"

void Weather::config(String key,String location,String language,String unit)
{
  _url = String("https://api.seniverse.com/v3/weather/now.json?key=") + key + String("&location=") + location + 
                  String("&language=") + language + String("&unit=") + unit;

}
int Weather::getPayload()
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
void Weather::getData()
{
        if(Weather::getPayload())
        {
          DynamicJsonDocument doc(4096);
          deserializeJson(doc, _payload);
          _text = doc["results"][0]["now"]["text"].as<String>();
          Serial.println("text:" + _text);
          _temperature = doc["results"][0]["now"]["temperature"].as<String>();
          Serial.println("temperature:" + _temperature);
          _date = (doc["results"][0]["last_update"].as<String>()).substring(0,10);
          Serial.println("date:" + _date);
        }
}
String Weather::getText()
{
  return _text;
}
String Weather::getTemperature()
{
  return _temperature;
}
String Weather::getDate()
{
  return _date;
}
