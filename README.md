## The BD-P3600 hacker's guide: A path to persistence and homebrew

> [!CAUTION]
> This guide assumes your are:
> 1. Capable of basic soldering
> 2. Poses a general knowledge of Linux
> 3. Not afraid to **BRICK YOUR Blue-ray player!** 
<center> <h2> 👹 !!! You can damage your player, so think twice before you go forward PLEASE!!!!! 👹 </h2></center>

> [!WARNING]
> The purpose of this guide is **not** for that of piracy, but rather homebrew and general shenanigans. 

Another guide can be found [here](https://www.avforums.com/threads/hacking-samsung-bd-p1620a-bd-p3600.1245419/) on avforums, although I found it to be lacking in many respects. Although it is still a useful resource. 
### Part 0: Required supplies
1. A soldering iron
2. Something capable of UART (A raspberry pi is what I am using)
3. An Ethernet cable with a router to plug it into
4. 4 male to female jumper wires compatible with being attached to the raspberry pi

### Part 1: Obtaining UART
For those unaware, UART ([Universal asynchronous receiver-transmitter](https://en.wikipedia.org/wiki/Universal_asynchronous_receiver-transmitter)) is a basic serial protocol that allows you to obtain a simple TTY, and lucky the BD-P3600 has easily accessible UART pins! 

To start out with, you need to set up the raspberry pi over ssh on wifi, as a million tutorials for this exist I will leave it as an exercise to the reader/google.

**THE RASPBERRY PI  DOES NOT HAVE UART ENABLED BY DEFAULT** to set it up see [step 1.5](step%201.5%20setting%20up%20the%20pi.md)

After the raspberry pi has UART enabled, you need to solder to the correct pins. Use this diagram to know where to solder to!

![/imgs/diagram.png]()
![/imgs/pcp-location.png]()
If you ignore my horrible solder job, here it what it should look like!
![/imgs/my-solder.jpg]()
if you did everything right, and it passes the smoke test, you've got yourself all you need on the hardware side!

To test out an make sure it works, run on your pi the command to view the UART then turn on the player! If your lucky you should see a boot-log spray onto the screen. You might need to first install minicom using apt.  

```bash
minicom -b 115200 -o -D /dev/ttyS0
```
(Depending on the raspberry pi version, you might need to try `/dev/ttyAMA0`, `/dev/serial0`, `/dev/serial1`, or `/dev/AMA0`. See https://spellfoundry.com/2016/05/29/configuring-gpio-serial-port-raspbian-jessie-including-pi-3-4/)
