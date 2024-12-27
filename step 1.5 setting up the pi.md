## Enabling UART on the pi

First, enter the config cli with:
```bash
sudo raspi-config
```

Interface options
![](imgs/rpi-config.png)
Serial port
![](imgs/rpi-serial.png)
Select **NO** to the shell being accessible over serial
![](imgs/rpi-login.png)
And select **YES** to the serial port hardware to be enabled
![](imgs/rpi-hardware.png)
And finally give it a quick reboot, and it should be enabled!
```bash
sudo reboot
```
