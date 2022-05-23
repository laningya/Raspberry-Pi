#include <wiringPi.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int main(int argc,char **argv)
{
    if(argc != 2)
    { 
        printf("Usage example:/pwm_hardware gpio port\n");
        return 0;
    }
    int gpio_port = atoi(argv[1]);

    wiringPiSetup();
    pinMode(gpio_port,PWM_OUTPUT);
    int i;
    while(1)
    {
        for(i = 0;i < 1024;i++)
        {
            pwmWrite(gpio_port,i);
            delay(1);
        }
        for(;i > -1;i--)
        {
            pwmWrite(gpio_port,i);
            delay(1);
        }
    }
    return 1;
}
