
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
Coin2 EECS205BITMAP <15, 15, 255,, offset Coin2 + sizeof Coin2>
	BYTE 0ffh,0ffh,0ffh,0ffh,049h,000h,024h,024h,024h,004h,049h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,000h,000h,004h,0dbh,0ffh,0ffh,0b6h,020h,024h,000h,024h,0ffh,0ffh,0ffh,000h
	BYTE 024h,0fbh,0ffh,0edh,0e0h,0e0h,0e0h,0e0h,0e0h,024h,024h,0ffh,0ffh,0ffh,000h,0ffh
	BYTE 0e0h,0e0h,0f6h,0ffh,0ffh,092h,040h,0e0h,0e0h,004h,000h,0ffh,000h,049h,0fbh,0e0h
	BYTE 0e0h,0fbh,0edh,0e0h,080h,044h,0e0h,0e0h,044h,004h,0dbh,000h,0ffh,0e0h,0e0h,0e0h
	BYTE 0fbh,0fbh,0e0h,0e0h,044h,0e0h,0e0h,0e0h,004h,000h,000h,0ffh,0e0h,0e0h,0e0h,0fbh
	BYTE 0fbh,0e0h,0e0h,044h,0e0h,0e0h,0e0h,004h,024h,000h,0ffh,0e0h,0e0h,0e0h,0fbh,0fbh
	BYTE 0e0h,0e0h,044h,0e0h,0e0h,0e0h,004h,024h,000h,0ffh,0e0h,0e0h,0e0h,0fbh,0fbh,0e0h
	BYTE 0e0h,044h,0e0h,0e0h,0e0h,004h,024h,000h,0ffh,0e0h,0e0h,0e0h,0fbh,0fbh,0e0h,0e0h
	BYTE 044h,0e0h,0e0h,0e0h,004h,000h,000h,049h,0fbh,0e0h,0e0h,0fbh,0fbh,0e0h,0a0h,044h
	BYTE 0e0h,0e0h,044h,004h,0dbh,0ffh,000h,0ffh,0e0h,0e0h,069h,024h,024h,024h,044h,0e0h
	BYTE 0e0h,004h,000h,0ffh,0ffh,000h,024h,0ffh,0e9h,0e0h,0c0h,0c0h,0e0h,0e0h,0e0h,024h
	BYTE 024h,0ffh,0ffh,0ffh,0ffh,000h,000h,004h,0c0h,0e0h,0e0h,0a0h,024h,024h,000h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,004h,004h,004h,024h,004h,049h,0ffh,0ffh,0ffh
	BYTE 0ffh
END
