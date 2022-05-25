#include <wiringPi.h>
#include <stdio.h>


int is_gpio_port(int gpio_port)
{
  if((gpio_port>=0&&gpio_port<=7)||(gpio_port>=21&&gpio_port<=29))
      return 1;
  else
      return 0;
}

int blink(int gpio_port,int delayms)
{
    if(is_gpio_port(gpio_port))
    {
        wiringPiSetup();
        pinMode(gpio_port,OUTPUT);
        int level = 0;
        while(1)
        {
            level = (level == 0) ? 1 : 0;
            digitalWrite(gpio_port,level);
            delay(delayms);
        }
        
    }
    else
    {
        printf("Error gpio_port\n");
        return 0;
    }
}

int hard_breathing_light(int gpio_port,int delayms)
{
    if(gpio_port == 1 || gpio_port == 23 || gpio_port == 24 || gpio_port == 26 )
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
    }
    else
    {
        printf("Error gpio_port\n");
        return 0;
    }
}

int soft_breathing_light(int gpio_port,int delayms,int pwmMAX)
{
    if(is_gpio_port(gpio_port))
    {
        wiringPiSetup();
        softPwmCreate(gpio_port,0,pwmMAX);
        int i = 0;
        while(1)
        {
            for(;i < pwmMAX;i++)
            {
                softPwmWrite(gpio_port,i);
                delay(delayms);
            }
            for(;i > -1;i--)
            {
                softPwmWrite(gpio_port,i);
                delay(delayms);
            }
        
            }
    }
    else
    {
        printf("Error gpio_port\n");
        return 0;
    }
}
