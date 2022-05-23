#include <wiringPi.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
int main(int argc,char *argv[])
{
    if(argc != 2)
    {
        printf("Usage example:./blank gpio_port\n");
    }

    int gpio_port = atoi(argv[1]);
    wiringPiSetup();
    pinMode(gpio_port,OUTPUT);

    int level = 0;
    while(1)
    {
        level =(0 == level)?1:0;
        digitalWrite(gpio_port,level);
        sleep(1);
    }
    return 0;
}
