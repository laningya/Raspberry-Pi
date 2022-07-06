#include <wiringPi.h>
#include <stdio.h>
#include <stdlib.h>
#include <softpwm.h>
#include <softTone.h>


int is_gpio_port(int gpio_port)
//判断输入是否为GPIO接口
{
  if((gpio_port>=0&&gpio_port<=7)||(gpio_port>=21&&gpio_port<=29))
      return 1;
  else
      return 0;
}

int blink(int gpio_port,int delayms)
//LED闪烁程序
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

int hard_breathing_light(int gpio_port,int delayms)
//硬件呼吸灯程序
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
//软件呼吸灯程序,由于wiringPi函数库限制，pwmMAX一般最大取100
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

int soft_tone(int gpio_port)
//无源蜂鸣器
{
    wiringPiSetup();

    if(0 != softToneCreate(gpio_port))
    {
        printf("Create software tone failed!\n");
        return 0;
    }
    int i;
    int loopCount = 0;
    int arrayLength = sizeof(scale)/sizeof(int);
    while(true)
    {
        printf("Has played the music for %d times\n",loopCount);

        for(i = 0; i < arrayLength; i++)
        {
            softToneWrite(gpio_port,scale[i]);
            delay(200);
        }
        delay(500);
        ++loopCount;
    }
}
int sense_light(int gpio_port1,int gpio_port2,int gpio_port3)
//红外模块
{
    wiringPiSetup();

    pinMode(gpio_port1,INPUT);
    pinMode(gpio_port2,OUTPUT);
    pinMode(gpio_port3,OUTPUT);
    int level = 0;
    while(1)
    {
        int currentLevel = digitalRead(gpio_port1);
        if(currentLevel != level)
        {
            printf("Current level:%d\n",currentLevel);
            digitalWrite(gpio_port2,currentLevel);
            digitalWrite(gpio_port3,currentLevel);
            level = currentLevel;
        }
        delay(2);
    }
}

int motor(int gpio_port1,int gpio_port2,int gpio_port3,int gpio_port4)
//电机模块
{
    int pins[4] = {gpio_port1,gpio_port2,gpio_port3,gpio_port4};

    wiringPiSetup();

    pinMode(gpio_port1,OUTPUT);
    pinMode(gpio_port2,OUTPUT);
    pinMode(gpio_port3,OUTPUT);
    pinMode(gpio_port4,OUTPUT);

    while(1)
    {
        int i = 0;
        int j = 0;
        for(i = 0;i < 4;i++)
        {
            for(j = 0;j < 4;j++)
            {
                int pinIndex = (1 == direction) ? (3-j) : j;
                if(j == i)
                {
                    digitalWrite(pins[pinIndex],1);
                }
                else
                {
                    digitalWrite(pins[pinIndex],0);
                }
                delay(delayms);
            }     
        }
    }
}
int pwm_sg90(int gpio_port,int i)
{
    if(gpio_port == 1 || gpio_port == 23 || gpio_port == 24 || gpio_port == 26 )
    {
        wiringPiSetup();
        pinMode(gpio_port,PWM_OUTPUT);
        pwmSetMode(PWM_MODE_MS);
        pwmSetClock(192);
        pwmSetRange(2000);
        pwmWrite(gpio_port,i)
    }
    else
    {
        printf("Error gpio_port\n");
        return 0;
    }
}


int soft_pwm_sg90(int gpio_port,int i)
{
    wiringPiSetup();
    softPwmCreate(gpio_port,0,200);
    softPwmWrite(gpio_port,i)
}
