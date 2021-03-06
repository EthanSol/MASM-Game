
      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include ./Include/stars.inc
include ./Include/lines.inc
include ./Include/trig.inc
include ./Include/blit.inc
include ./Include/game.inc

;; Has keycodes
include ./Include/keys.inc

.DATA
CarAnimation EECS205BITMAP <48, 48, 02bh,, offset CarAnimation + sizeof CarAnimation>
	BYTE 0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,0fch,0fch,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h
	BYTE 0f8h,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0f8h
	BYTE 0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0fch,0fch,0fch
	BYTE 0fch,0fch,0fch,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h
	BYTE 060h,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,060h
	BYTE 060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,0fch,0fch,0fch
	BYTE 0fch,0fch,0fch,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h
	BYTE 080h,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,080h
	BYTE 080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,0fch,0fch,0fch
	BYTE 080h,080h,080h,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,0fch,0fch,0fch,0fch,0e9h,0e9h,0e9h,0e9h,0e9h,0e9h,0fch,0fch,0fch,0fch,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,080h,080h,080h
	BYTE 080h,080h,080h,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,0fch,0fch,0fch,0fch,0e9h,0e9h,0e9h,0e9h,0e9h,0e9h,0fch,0fch,0fch,0fch,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,080h,080h,080h
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,0fch,0fch,0fch,0fch,0e9h,0e9h,0e9h,0e9h,0e9h,0e9h,0fch,0fch,0fch,0fch,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 007h,007h,007h,007h,007h,007h,007h,007h,007h,007h,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,0fch,0fch,0fch,0fch,0e9h,0e9h,0e9h,0e9h,0e9h,0e9h,0fch,0fch,0fch,0fch,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,007h,007h,007h,007h,007h,007h,007h,007h,007h,007h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,0fch,0fch,0fch,0fch,0e9h,0e9h,0e9h,0e9h,0e9h,0e9h,0fch,0fch,0fch,0fch,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,007h,007h,007h,007h,007h,007h
	BYTE 007h,0fch,0fch,0fch,0fch,0e9h,0e9h,0e9h,0e9h,0e9h,0e9h,0fch,0fch,0fch,0fch,007h
	BYTE 007h,007h,007h,007h,007h,007h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0fch,0fch,0fch,0fch,0e9h,0e9h,0e9h,0e9h,0e9h,0e9h,0fch,0fch,0fch,0fch,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0fch,0fch,0fch,0fch,0e9h,0e9h,0e9h,0e9h,0e9h,0e9h,0fch,0fch,0fch,0fch,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,06fh,06fh
	BYTE 06fh,0fch,0fch,0fch,0fch,0e9h,0e9h,0e9h,0e9h,0e9h,0e9h,0fch,0fch,0fch,0fch,06fh
	BYTE 06fh,06fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,002h,002h
	BYTE 002h,0fch,0fch,0fch,0fch,0e9h,0e9h,0e9h,0e9h,0e9h,0e9h,0fch,0fch,0fch,0fch,002h
	BYTE 002h,002h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,007h,007h,027h,027h,0ffh,0ffh
	BYTE 0ffh,0fch,0fch,0fch,0fch,0e9h,0e9h,0e9h,0e9h,0e9h,0e9h,0fch,0fch,0fch,0fch,0ffh
	BYTE 0ffh,0ffh,027h,027h,007h,007h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,02bh,02bh,02bh,02bh,0ffh,0ffh
	BYTE 0ffh,0fch,0fch,0fch,0fch,0e9h,0e9h,0e9h,0e9h,0e9h,0e9h,0fch,0fch,0fch,0fch,0ffh
	BYTE 0ffh,0ffh,02bh,02bh,02bh,02bh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 007h,007h,007h,007h,007h,007h,007h,007h,007h,007h,02bh,02bh,02bh,02bh,007h,007h
	BYTE 007h,0fch,0fch,0fch,0fch,0e9h,0e9h,0e9h,0e9h,0e9h,0e9h,0fch,0fch,0fch,0fch,007h
	BYTE 007h,007h,02bh,02bh,02bh,02bh,007h,007h,007h,007h,007h,007h,007h,007h,007h,007h
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,0fch,0fch,0fch,0fch,0e9h,0e9h,0e9h,0e9h,0e9h,0e9h,0fch,0fch,0fch,0fch,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,0fch,0fch,0fch,0fch,0e9h,0e9h,0e9h,0e9h,0e9h,0e9h,0fch,0fch,0fch,0fch,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,0fch,0fch,0fch,0fch,0e9h,0e9h,0e9h,0e9h,0e9h,0e9h,0fch,0fch,0fch,0fch,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,0fch,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0e9h,0e9h,0e9h,0e9h,0e9h,0e9h,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,0fch,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,00bh,00bh,00bh,00bh,0fch,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0e4h,0e4h,0e4h,0e4h,0e4h,0e4h,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,0fch,00bh,00bh,00bh,00bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,0f8h,0f8h,0f8h,0f8h,0fch,0fch
	BYTE 0fch,0f8h,0f8h,0f8h,0f8h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0f8h,0f8h,0f8h,0f8h,0fch
	BYTE 0fch,0fch,0f8h,0f8h,0f8h,0f8h,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,0fch,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,0e4h,0e4h,0e4h,0e4h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e4h,0e4h,0e4h,0e4h,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0fch,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,0fch,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,0ffh,0ffh,0ffh,0ffh,000h,000h,000h,000h,000h,000h,0ffh,0ffh,0ffh,0ffh,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0fch,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,0fch,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,0ffh,0ffh,0ffh,0ffh,000h,000h,000h,000h,000h,000h,0ffh,0ffh,0ffh,0ffh,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0fch,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,0fch,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0fch,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,0fch,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0fch,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,0fch,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0fch,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,0fch,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0fch,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,0fch,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,0e0h,0e0h,0e0h,0e0h,000h,000h,000h,000h,000h,000h,0e0h,0e0h,0e0h,0e0h,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0fch,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,0fch,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,0a0h,0a0h,0a0h,0a0h,000h,000h,000h,000h,000h,000h,0a0h,0a0h,0a0h,0a0h,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0fch,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,0fch,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,0f8h,0f8h,0f8h,0f8h,0a0h,0a0h,0a0h,0a0h,0a0h,0a0h,0f8h,0f8h,0f8h,0f8h,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0fch,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 007h,007h,007h,007h,007h,007h,007h,007h,007h,007h,0fch,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0fch,007h,007h,007h,007h,007h,007h,007h,007h,007h,007h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fch,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0a0h,0a0h,0a0h,0a0h,0a0h,0a0h,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0fch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fch,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0a0h,0a0h,0a0h,0a0h,0a0h,0a0h,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0fch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fch,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0fch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fch,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0fch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fch,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0fch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0f8h,0f8h,0f8h,0f8h,0fch,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,0fch,0f8h,0f8h,0f8h,0f8h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0f8h,0f8h,0f8h,0f8h,0fch,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,0fch,0f8h,0f8h,0f8h,0f8h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0f8h,0f8h,0f8h,0f8h,0fch,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,0fch,0f8h,0f8h,0f8h,0f8h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,0f8h,0f8h,0f8h,0f8h,02bh,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,02bh,0f8h,0f8h,0f8h,0f8h,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,0f8h,0f8h,0f8h,0f8h,02bh,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,02bh,0f8h,0f8h,0f8h,0f8h,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,0f8h,0f8h,0f8h,0f8h,080h,080h
	BYTE 080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h
	BYTE 080h,080h,0f8h,0f8h,0f8h,0f8h,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,0f8h,0f8h,0f8h,0f8h,060h,060h
	BYTE 060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h
	BYTE 060h,060h,0f8h,0f8h,0f8h,0f8h,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h
	BYTE 0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h
	BYTE 0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh
	BYTE 02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h
	BYTE 0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h
	BYTE 0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh,02bh

END