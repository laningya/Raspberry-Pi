#include <wiringPi.h>
int rotate(int *pins,int direction,int delayms);
int main()
{
    int pins[4]={0,1,2,3};
    wiringPiSetup();
    pinMode(pins[0],OUTPUT);
    pinMode(pins[1],OUTPUT);
    pinMode(pins[2],OUTPUT);
    pinMode(pins[3],OUTPUT);
    while(1)
    {
        rotate(pins,1,4);
    }
}
int rotate(int *pins,int direction,int delayms)
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

