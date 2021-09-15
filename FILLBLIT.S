; ET4000 direct draw test
; 640x480x8bits
; filling screen with blitter
; 09/2021 by fenarinarsa


	clr.l	-(sp)
	move.w	#$20,-(sp)
	trap	#1
	addq.w	#6,sp

	; get the framebuffer address through XBIOS
	move.w	#2,-(sp)
	trap	#14
	addq.l	#2,sp

	move.w	#320,$ffff8a36.w  ; x word count
	clr.w	$ffff8a20.w   ; src x byte increment
	clr.w	$ffff8a22.w   ; src y byte increment
	move.w	#2,$ffff8a2e.w ; dst x increment
	move.w     #2,$ffff8a30.w ; dst y increment
	clr.b	$ffff8a3d.w    ; skew
	move.w	#-1,$ffff8a28.w ; endmask1
	move.w	#-1,$ffff8a2a.w ; endmask2
	move.w	#-1,$ffff8a2c.w ; endmask3
	move.w	#$010F,$ffff8a3a.w    ; HOP+OP: 1s fill
	move.l	#$5000,$ffff8a24.w   ; src
	moveq	#3,d1
	move.w	#480,$ffff8a38.w ; y count
	move.l	d0,$ffff8a32.w   ; dest
	move.b	#%11000000,$ffff8a3c.w ; start HOG
	nop
	nop

	; CONIN
	move.w	#$1,-(sp)
	trap	#1
	addq.l	#2,sp

	clr.l	-(sp)
	move.w	#$20,-(sp)
	trap	#1
	addq.w	#6,sp

	clr.w 	-(sp)
	trap	#1