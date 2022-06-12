from machine import Pin
from time inport sleep

led = Pin(25,OUTPUT)
while True:
    led.toggle()
    sleep(1)
