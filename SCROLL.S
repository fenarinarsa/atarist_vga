; ET4000 hardware scroll test
; 640x480x8 bits
; framebuffer located at $C00000 (Mega STE)
; registers located at $DC0000 (Mega STE)
; 16/09/2021 by fenarinarsa

; note: adding $FE000000 to VME addresses
; makes them TT compatible without breaking
; things on Mega STE
SCREEN	EQU	$FEC00000
DAC_PEL	EQU	$FEDC03C6
DAC_IR	EQU	$FEDC03C7
DAC_IW	EQU	$FEDC03C8
DAC_D	EQU	$FEDC03C9
CRTC_I	EQU	$FEDC03D4
CRTC_D	EQU	$FEDC03D5
INSTATUS1	EQU	$FEDC03DA
LStartH	EQU	$33
LStartM	EQU	$C
LStartL	EQU	$D

	; SUPER
	clr.l	-(sp)
	move.w	#$20,-(sp)
	trap	#1
	addq.w	#6,sp

	; copy image to video RAM with the blitter
	move.w	#960,$ffff8a38.w ; y count
	move.w	#320,$ffff8a36.w  ; x word count
	move.w	#2,$ffff8a20.w   ; src x byte increment
	move.w	#2,$ffff8a22.w   ; src y byte increment
	move.w	#2,$ffff8a2e.w ; dst x increment
	move.w     #2,$ffff8a30.w ; dst y increment
	clr.b	$ffff8a3d.w    ; skew
	move.w	#-1,$ffff8a28.w ; endmask1
	move.w	#-1,$ffff8a2a.w ; endmask2
	move.w	#-1,$ffff8a2c.w ; endmask3
	move.w	#$0203,$ffff8a3a.w    ; HOP+OP: $010F=1fill/$0203=copy
	move.l	#bmpdata,$ffff8a24.w   ; src
	move.l	#SCREEN+(640*480),$ffff8a32.w   ; dest
	move.b	#%11000000,$ffff8a3c.w ; start HOG
	nop
	nop

; debug palette
;	bra	setpalette
;	move.w	#50,d0
;	lea	$c00000,a0	
;debug	move.l	a0,a1
;	move.w	#0,d1
;.dbg	move.b	d1,(a1)+
;	move.b	d1,(a1)+
;	addq	#1,d1
;	cmp.w	#256,d1
;	bne.s	.dbg
;	adda.w	#640,a0
;	dbra	d0,debug

; 18-bits palette so each component must be >>2	
setpalette	
	move.b	#$FF,DAC_PEL ; pixel mask
	move.w	#255,d0
	lea	palette(pc),a0
	move.b	#0,DAC_IW	; start pal index #0
.pal	move.b	(a0)+,d1
	move.b	(a0)+,d2
	move.b	(a0),d3
	addq	#2,a0	; skip 4th byte
	lsr.b	#2,d1
	lsr.b	#2,d2
	lsr.b	#2,d3
	move.b	d3,DAC_D	; write R
	move.b	d2,DAC_D	; write G
	move.b	d1,DAC_D	; write B
	dbra	d0,.pal

	move.w	#960+240,d0
	; +160=1line scrolling
	; why 160 instead of 640 is currently a mystery to me
scroll	add.l	#160,address
	bsr	vsync
	bsr	set_addr
	dbra	d0,scroll
	
	bsr	vsync
	; restore screen
	move.l	#SCREEN,address
	bsr	set_addr

end	
	; CONIN
	move.w	#$1,-(sp)
	;trap	#1
	addq	#2,sp

	clr.l	-(sp)
	move.w	#$20,-(sp)
	trap	#1
	addq	#6,sp

	clr.w 	-(sp)
	trap	#1

	; poll vsync bit
vsync	btst	#3,INSTATUS1
	bne.s	vsync
.vs	btst	#3,INSTATUS1
	beq.s	.vs
	rts

	; set screen base address
set_addr	move.b	#LStartL,CRTC_I
	move.b	address+3,CRTC_D
	move.b	#LStartM,CRTC_I
	move.b	address+2,CRTC_D
	move.b	#LStartH,CRTC_I
	move.b	address+1,CRTC_D
	rts
	
address	dc.l	SCREEN

	; BMP image, 640x960 256 colors
	; saved with photoshop
	; 8-bits Windows, flipped rows 
image	incbin	'H:\iruma.bmp'

	; hardcoded offsets for BMP
palette	EQU	image+$36
bmpdata	EQU	image+$436
