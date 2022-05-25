#include <wiringPi.h>
#include <stdio.h>

int main()
{
    wiringPiSetup();

    pinMode(7,INPUT);
    pinMode(0,OUTPUT);
    pinMode(1,OUTPUT);

    int level = 0;
    while(1)
    {
        int currentLevel = digitalRead(7);
        if(currentLevel != level)
        {
            printf("Current level:%d\n",currentLevel);
            digitalWrite(0,currentLevel);
            digitalWrite(1,currentLevel);
            level = currentLevel;
        }
        delay(2);
    }
    return 0;
}
