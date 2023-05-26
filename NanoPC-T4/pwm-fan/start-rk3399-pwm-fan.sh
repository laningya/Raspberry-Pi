#!/bin/bash
 
echo $$ > /var/run/fan.pid
 
echo 0 > /sys/class/pwm/pwmchip1/export
 
echo 0 > /sys/class/pwm/pwmchip1/pwm0/enable
echo 50000 > /sys/class/pwm/pwmchip1/pwm0/period
echo 1 > /sys/class/pwm/pwmchip1/pwm0/enable
 
while true
do
        temp=$(cat /sys/class/thermal/thermal_zone0/temp)
        if [ $temp -gt 48000 ]; then
                echo 1000 > /sys/class/pwm/pwmchip1/pwm0/duty_cycle;
        elif  [ $temp -gt 43000 ]; then
                echo 20000 > /sys/class/pwm/pwmchip1/pwm0/duty_cycle;
        elif  [ $temp -gt 38000 ]; then
                echo 30000 > /sys/class/pwm/pwmchip1/pwm0/duty_cycle;
        elif  [ $temp -gt 33000 ]; then
                echo 40000 > /sys/class/pwm/pwmchip1/pwm0/duty_cycle;
        else
                echo 50000 > /sys/class/pwm/pwmchip1/pwm0/duty_cycle;
        fi
        sleep 1s;
done