#include <stdio.h>
#include <wiringPi.h>
#include <softPwm.h>
#define PWM_PIN 0

int main()
{
        wiringPiSetup();
        softPwmCreate(PWM_PIN,0,200);
        while(1){
        softPwmWrite(PWM_PIN,25);
        delay(20);
        }
}
