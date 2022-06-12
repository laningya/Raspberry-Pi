#include <wiringPi.h>
#include <softPwm.h>
#include <stdio.h>
#define PWM_PIN 1
int main()
{
    wiringPiSetup();
    pinMode(PWM_PIN,PWM_OUTPUT);
    pwmSetMode(PWM_MODE_MS);
    pwmSetClock(192);
    pwmSetRange(2000);
    while(1){
    pwmWrite(PWM_PIN,250);
    delay(20);
}}
