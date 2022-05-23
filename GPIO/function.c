#include <wiringPi.h>

int blink(int gpio_port,int dalayms)
{
  wiringPiSetup();
  pinMode(gpio_port,OUTPUT);
  int level = 0;
  while(1)
  {
    level = (level == 0) ? 1 : 0;
    digitalWrite(gpio_port,level);
    delay(dalyms);
  }
  return 1;
}
int breathing_light(int gpio_port,int delayms)
{
  wiringPiSetup();
  pinMode(gpio_port,PWM_OUTPUT);
  int i = 0;
  while(1)
  {
    for(; i < 1024;i++)
    {
      pwmWrite(gpio_port,i);
      delay(delayms);
    }
    for(;i > -1;i--)
    {
      pwmWrite(gpio_port,i);
      delay(delayms);
    }
  }
  return 1;
}
int 
