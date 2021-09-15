; ET4000 direct draw test
; 640x480x24 bits BGR
; framebuffer located at $C00000 (MegaSTE)
; fill screen in purple
; 09/2021 by fenarinarsa

SCREEN	EQU	$C00000

	lea	SCREEN+(640*480*3),a0
	move.w	#480-1,d6
	move.l	#$ff0088ff,d0
	move.l	#$0088ff00,d1
	move.l	#$88ff0088,d2
	move.l	#$ff0088ff,d3
	move.l	#$0088ff00,d4
	move.l	#$88ff0088,d5
	move.l	d0,a1
	move.l	d1,a2
	move.l	d2,a3
	move.l	d3,a4
	move.l	d4,a5
	move.l	d5,a6

loopY	move.w	#(640/16)-1,d7
	
loopX	movem.l	d0-d5/a1-a6,-(a0)
	dbra	d7,loopX
	dbra	d6,loopY

	; CONIN
	move.w	#$1,-(sp)
	trap	#1
	addq	#2,sp

	clr.w 	-(sp)
	trap	#1