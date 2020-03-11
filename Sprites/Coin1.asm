
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
Coin1 EECS205BITMAP <15, 15, 255,, offset Coin1 + sizeof Coin1>
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0feh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0dah,0dah,0fah,0dah,0dah,0dah,0dah,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0b5h,0feh,0b5h,0b4h,0b5h,0b4h,0d5h,0f9h,0b5h,0ffh,0ffh,0ffh,0ffh,0ffh,0b5h
	BYTE 0feh,090h,0fdh,0fdh,0f9h,0fdh,0f9h,0b0h,0f9h,0b5h,0ffh,0ffh,0ffh,0dah,0feh,090h
	BYTE 0feh,0fdh,0b4h,0b0h,0d8h,0fdh,0f8h,0d4h,0f9h,0fah,0ffh,0ffh,0dah,0b5h,0fdh,0fdh
	BYTE 0fdh,0d4h,0d4h,0f8h,0f8h,0f8h,0f8h,0f8h,0d4h,0ffh,0ffh,0dah,0b0h,0fdh,0fdh,0fdh
	BYTE 0d4h,0f4h,0f8h,0f8h,0f8h,0f8h,0f8h,0d4h,0ffh,0ffh,0d9h,0d5h,0fdh,0fdh,0fdh,0d4h
	BYTE 0f4h,0f8h,0f8h,0f4h,0f4h,0f8h,0d4h,0ffh,0ffh,0d9h,0d4h,0f8h,0f8h,0f8h,0d4h,0f8h
	BYTE 0f8h,0f4h,0f4h,0d4h,0f8h,0d4h,0ffh,0ffh,0d5h,0f4h,0f8h,0f8h,0f8h,0d4h,0f8h,0f8h
	BYTE 0f4h,0d4h,0d4h,0f9h,0d5h,0ffh,0ffh,0dah,0f9h,0d4h,0f8h,0f4h,0d4h,0f4h,0f8h,0d4h
	BYTE 0d4h,0f9h,0d5h,0fah,0ffh,0ffh,0ffh,0b5h,0f8h,0f8h,0d4h,0f4h,0f8h,0d4h,0d4h,0f9h
	BYTE 0d5h,0b1h,0ffh,0ffh,0ffh,0ffh,0ffh,0b5h,0d5h,0f8h,0f8h,0f8h,0f8h,0f9h,0d5h,0b1h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fah,0d5h,0d4h,0d4h,0b4h,0b5h,0fah,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh
END