# atarist_vga
Various tests of direct draw to ET4000 VGA hardware on Atari ST.

More specifically, it was tested on Atari Mega STE with a NOVA adapter and an ET4000 VGA card (ICS 5301-2 GenDAC 24-bit).  
I did that mostly by curiosity because the documentation on ST is very scarce and existing drivers are not open source.  
Note that writing to the ET4000's RAM is very slow on Mega STE (~65% slower than accessing ST-RAM) and the ET4000/AX do not have hardware acceleration (bitblt). AFAIK the only ST compatible VGA card with bitblt is the ISA ATI Mach32 (Mach64 for TT).

**DISCLAIMER**  
To make compatible software on Atari VGA cards, you must use VDI calls and avoid low-level calls. Doing so will make your code very hardware dependant unless you implement a full detection library (like VGA lib in 'More Resources').

### FILL.S
Software screen fill, must run in 800x600x24 bits (true color)  
### FILLBLIT.S
Blitter screen fill, must run in 640x480x8 bits  
### SCROLL.S
Hardware vertical scroll, must run in 640x480x8 bits  

## Videos

Output of SCROLL.S  
https://peertube.fenarinarsa.com/w/cz5sD96ygSEBj6v6yRoXUu

Nova card running on Mega STE  
https://peertube.fenarinarsa.com/w/u2ws5y96EgYFXXpxrmMYNN

320x240 24 bits (true color)  
https://peertube.fenarinarsa.com/w/w7qofvdpsCsgroRjp3QcS9

## More resources

EmuTOS NOVA driver https://github.com/emutos/emutos/blob/master/bios/nova.c  
rtems-graphic-toolkit ET4000 VGA lib https://github.com/RTEMS/rtems-graphics-toolkit/blob/master/svgalib-1.4.3/src/et4000.c  
ET4000 data book http://www.bitsavers.org/components/tsengLabs/Tseng_Labs_ET4000_Graphics_Controller_1990.pdf  
read ET4000 registers https://comp.lang.asm.x86.narkive.com/tUGRdLYm/gamma-correction  
Mega STE NOVA drivers by Itek:  https://silicon-heaven.org/atari/nova/  
NOVA Grafikkarte https://mikrosk.github.io/doitarchive/doitf030/0807.htm  
NOVA graphic cards on TT https://sites.google.com/site/probehouse/atari-hardware-mods/nova-graphic-cards-on-tt

