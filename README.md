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

![](imgs/diagram.png)
![](imgs/pcp-location.png)
If you ignore my horrible solder job, here it what it should look like!
![](imgs/my-solder.jpg)
if you did everything right, and it passes the smoke test, you've got yourself all you need on the hardware side!

To test out an make sure it works, run on your pi the command to view the UART then turn on the player! If your lucky you should see a boot-log spray onto the screen. You might need to first install minicom using apt.  

```bash
minicom -b 115200 -o -D /dev/ttyS0
```
(Depending on the raspberry pi version, you might need to try `/dev/ttyAMA0`, `/dev/serial0`, `/dev/serial1`, or `/dev/AMA0`. See https://spellfoundry.com/2016/05/29/configuring-gpio-serial-port-raspbian-jessie-including-pi-3-4/)

If still nothing happens, check your connections, and use a multi-meter to make sure you didn't bridge any of the pins you shouldn't have
### Part 2: Logging in and making a copy of the firmware

There are two methods to login to the DVD player, and if your anything like me you will probably need both. 

1. Logging in the "proper" way:
	* After the DVD player has booted hit CTRL-C
	* Use the username `root` and the password of `tkfkddlf`
		* Note: This password appears to be a reference to a Korean pop song, but evidence is inconclusive. Samsung also uses this for many products
	* At this point you are in a root shell
2. Via the boot loader in single user mode
	* **SPAM CTRL-C** while the DVD player is booting, if your lucky you will see `CFE> `, otherwise you waited too long and need to try again. 
		* You can reboot it either from pressing the physical power button, or running the `reboot` command in the root shell. The latter is the easiest option as you can spam CTRL-C as soon the the command is executed. 
		* You will find the boot loader to be your best friend during this process
	* Run `printenv` to find your players default boot command, mine looks like this:
	```bash
splash -480p;boot -z -elf flash0.kernel: 'root=/dev/romblock2 memcfg=384 console=1,115200n8 BDVD_BOOT_AUTOSTART=y ro'
	```
	* To boot into single user mode, to bypass the login prompt, simply add the `single` argument, and since we are here replace `ro` with `rw` to disable write protection. So now you should have something like:
	```bash
boot -z -elf flash0.kernel: 'root=/dev/romblock2 memcfg=384 console=1,115200n8 BDVD_BOOT_AUTOSTART=y single rw'
	```
	* Run that command in CFE to get into the operating system without a password, or executing most startup programs
	* To do mostly anything you need to mount the proc
```bash
mount -t proc none /proc
```

After playing around for a while, you might notice that the entire OS (apart from the pstor) is  ephemeral, meaning any saved changes are reverted upon reboot, even if the write protection is disabled.

Either way, once you are in the OS, the **FIRST THING TO DO** is to dumping the firmware for safety. It is best to do your own, as it is likely unique to your device, and other peoples might not work for you!

To extract the firmware, you need a `fat32` formatted USB flash drive. 

It appears to me you can only write to the flash drive using the second login method (single user mode) with write protection disables, so I will be using that for the guide. 

After you are logged, and have mounted the proc with the command above, plug in your flash drive. And wait until you see something like this:
```plaintext
sda: assuming drive cache: write through  
	sda:  
Attached scsi removable disk sda at scsi4, channel 0, id 0, lun 0  
Attached scsi generic sg1 at scsi4, channel 0, id 0, lun 0,  type 0
```
The `sda` here is the device file we will be using. I like to use the `/var` directory for the usb when using the second method, as it is not doing anything right now. Mount the USB drive with the following (Otherwise with the "proper" login method `/etc/` is writable, so make a dir and mount to that):
```bash
mount /dev/sda /var
```
Replace `sda` with whatever device file it gives you, its not always `sda`!


Now to view what partitions exits cat out `/proc/mtd`
```
# cat /proc/mtd  
dev:    size   erasesize  name  
mtd0: 00180000 00004000 "cfe"  
mtd1: 00500000 00004000 "vmlinux"  
mtd2: 02800000 00004000 "rootfs"  
mtd3: 007fc000 00004000 "pstor"  
mtd4: 00140000 00004000 "splash"  
mtd5: 00020000 00004000 "drmregion"  
mtd6: 000c0000 00004000 "rawnvr"  
mtd7: 00004000 00004000 "macadr"  
mtd8: 00020000 00004000 "nvram"  
mtd9: 00640000 00004000 "swap"  
mtd10: 04000000 00004000 "all"
```
**DO NOT EVER WRITE THE `cfe` or `all`!**

To extract the firmware you can use the `dd` command. 