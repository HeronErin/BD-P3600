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

### Part 1: Obtaining UART
For those unaware, UART ([Universal asynchronous receiver-transmitter](https://en.wikipedia.org/wiki/Universal_asynchronous_receiver-transmitter)) is a basic serial protocol that allows you to obtain a simple TTY, and lucky the BD-P3600 has easily accessible UART pins! 
