## Motor remote control
A Raspberry Pi Pico W is used as a remote control for an ESP32 to adjust motor speed over PWM output.
The motor speed is set on the pico in 5% or 20% steps which is send to the ESP32 via the integrated wifi modules using UDP for minimal latency.
Pico sends a new package if a new input is received or every 50ms.
The ESP32 checks the time of last received packages and if nothing was received for 1 second, the motor turns off.
This is used as fail save mechanic if the vehicle is out of transmission range or if the pico controller has some form of defect.
