; #########################################################################
;
;   stars.asm - Assembly file for CompEng205 Assignment 1
;
;   ===============Ethan Solomon================
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive


include ./Include/stars.inc

.DATA

	;; If you need to, you can place global variables here

.CODE

DrawStarField proc
      ;Used a random number generator to generate coordinates for 26 stars
	invoke DrawStar, 393, 60;;
      invoke DrawStar, 317, 368;;
      invoke DrawStar, 279, 164;;
      invoke DrawStar, 242, 147;;
      invoke DrawStar, 602, 186;;
      invoke DrawStar, 255, 336;;
      invoke DrawStar, 173, 393;;
      invoke DrawStar, 640, 33;;
      invoke DrawStar, 398, 275;;
      invoke DrawStar, 560, 368;;
      invoke DrawStar, 104, 257;;
      invoke DrawStar, 123, 202;;
      invoke DrawStar, 133, 98;;
      invoke DrawStar, 322, 202;;
      invoke DrawStar, 429, 207;;
      invoke DrawStar, 287, 101;;
      invoke DrawStar, 475, 208;;
      invoke DrawStar, 20, 105;;
      invoke DrawStar, 570, 236;;
      invoke DrawStar, 485, 169;;
      invoke DrawStar, 554, 366;;
      invoke DrawStar, 79, 402;;
      invoke DrawStar, 415, 351;;
      invoke DrawStar, 570, 415;;
      invoke DrawStar, 470, 101;;
      invoke DrawStar, 221, 297;;
      


	ret  			; Careful! Don't remove this line
DrawStarField ENDP



END
