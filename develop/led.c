#include <wiringPi.h>

char LED = 0;
int main()
{
    if(wiringPiSetup() < 0)
        return 0;
    pinMode(LED,OUTPUT);
    while(1)
    {
        digitalWrite(LED,1);
        delay(200);
        digitalWrite(LED,0);
        delay(200);
    }
}
