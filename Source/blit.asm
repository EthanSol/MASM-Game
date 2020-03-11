; #########################################################################
;
;   blit.asm - Assembly file for CompEng205 Assignment 3
;
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include ./Include/stars.inc
include ./Include/lines.inc
include ./Include/trig.inc
include ./Include/blit.inc


.DATA

	;; If you need to, you can place global variables here
	
.CODE

DrawPixel PROC USES esi ebx ecx x:DWORD, y:DWORD, color:DWORD
      ;;bound checking 0 <= x < 640; 0 <= y < 480
      ;;allows other functions to ignore screen bounds
      cmp x, 639
      jg DONE
      cmp x, 0
      jl DONE
      cmp y, 479
      jg DONE
      cmp y, 0
      jl DONE

      ;;DRAWING
       
      ;;Calculate byte first
      mov eax, y
      mov esi, 640
      imul esi;add the row offset
      add eax, x; add the column offset

      mov ecx, color
      mov ebx, ScreenBitsPtr
      mov BYTE PTR [ebx + eax], cl; place the color value in the buffer


DONE:
	ret 			; Don't delete this line!!!
DrawPixel ENDP

DrawBox PROC USES ebx ecx x0:DWORD, y0:DWORD, x1:DWORD, y1:DWORD, color:DWORD
            mov ecx, x0
            jmp X_COND

      NextRow:
            mov ebx, y0
            jmp Y_COND
      NextPixel:
            invoke DrawPixel, ecx, ebx, color
            inc ebx
      Y_COND:
            cmp ebx, y1
            jle NextPixel

            inc ecx
      X_COND:
            cmp ecx, x1
            jle NextRow


            ret
DrawBox ENDP

EraseBlit PROC uses ebx esi edi ptrBitmap:PTR EECS205BITMAP, xcenter:DWORD, ycenter:DWORD
      LOCAL top:DWORD, bot:DWORD, left:DWORD, right:DWORD
			mov ebx, ptrBitmap

            ;;initialize locals
            mov eax, xcenter
            mov left, eax
			mov right, eax

            mov eax, (EECS205BITMAP PTR [ebx]).dwWidth
            sar eax, 1
			add eax, 20; buffer
            sub left, eax
			add right, eax

            mov eax, ycenter
            mov top, eax
			mov bot, eax

            mov eax, (EECS205BITMAP PTR [ebx]).dwHeight
            sar eax, 1
			add eax, 20; buffer
            sub top, eax
			add bot, eax


            ;;Paint blit black
            mov esi, left

            jmp cond_1

      Loop_1:

            mov edi, top
            jmp cond_2
      
      Loop_2:

            invoke DrawPixel, esi, edi, 0
            inc edi
      cond_2:
            cmp edi, bot
            jle Loop_2

            inc esi
      cond_1:
            cmp esi, right
            jle Loop_1

            ret
EraseBlit ENDP


BasicBlit PROC USES esi edi ebx edx ebx ecx ptrBitmap:PTR EECS205BITMAP , xcenter:DWORD, ycenter:DWORD
      LOCAL left:DWORD, dwWidth:DWORD, top:DWORD, dwHeight:DWORD, bTransparent:DWORD ;;Local variables for the procedure

            ;;Set local variables (import bitmap)
            mov ebx, ptrBitmap

            ;;set Transparency
            xor eax, eax
            mov al, (EECS205BITMAP PTR [ebx]).bTransparent
            mov bTransparent, eax;;
            xor eax, eax;; clear eax

            ;;initialize width and height
            mov esi, (EECS205BITMAP PTR [ebx]).dwWidth;; esi holds the width
            mov edi, (EECS205BITMAP PTR [ebx]).dwHeight;; edi holds the height
            mov dwWidth, esi;
            mov dwHeight, edi;

            shr esi, 1;; divide both by 2 so that we 
            shr edi, 1;; can find the bitmap boundaries

            ;;set Top/Left corner locals
            neg esi;; subtract half width from xcenter
            add esi, xcenter;; holds left bound
            mov left, esi;;

            neg edi;; subtract half height from ycenter
            add edi, ycenter;; holds upper bound
            mov top, edi;;


            ;;Drawing start
            mov edi, 0;; initialize row index to 0
            mov ecx, top;; intitialize pixel-y to the top

            jmp RowCond
      RowLoop:

            mov esi, 0;; reset the column index to 0
            mov ebx, left;; reset pixel-x to the left side

      ;======= Loop Contents =====
      ColLoop:
            xor eax, eax
            mov eax, edi;; set eax to the row index
            mov edx, dwWidth;; mutliply eax by the width of each row
            imul edx;
            add eax, esi;; add to eax the column index

            add eax, ptrBitmap;; determine location of the colors array
            add eax, 16;; start of lpBytes

            movzx edx, BYTE PTR [eax];; place the color into edx
            cmp edx, bTransparent;;
            je Continue

            invoke DrawPixel, ebx, ecx, edx;; draw the pixel

      Continue:
      ;========= Column Loop Conditions ==========
            inc esi;; increment the column
            inc ebx;; increment pixel-x
      ColCond:
            cmp esi, dwWidth;;
            jl ColLoop;;

      ;========== Row Loop Conditions ==========
            inc edi;; increment the row
            inc ecx;; increment pixel-y

      RowCond:
            cmp edi, dwHeight
            jl RowLoop



            ret 			; Don't delete this line!!!	
BasicBlit ENDP


;;multiplication function to multiply an int with a fixed point and return an int
INT_FXPT_MULT PROC USES ebx edx dwInt:DWORD, fxd:FXPT   
      mov eax, dwInt;;put args in registers
      mov ebx, fxd;;

      shl eax, 16;; convert int to fxd
      imul ebx;; multiply (int << 16) * fxpt

      mov eax, edx;; move the integer (higher result) bits to eax

      ret
INT_FXPT_MULT ENDP


RotateBlit PROC USES esi edi ebx ecx edx lpBmp:PTR EECS205BITMAP, xcenter:DWORD, ycenter:DWORD, angle:FXPT
      LOCAL cosa:FXPT, sina:FXPT, shiftX:DWORD, shiftY:DWORD, dstWidth:DWORD, dstHeight:DWORD, srcX:DWORD, srcY:DWORD, dstX:DWORD, dstY:DWORD, bTransparent:DWORD

;;=========================
      ;;determine Sin(angle) and Cos(angle)
      mov eax, angle
      invoke FixedCos, eax
      mov cosa, eax

      mov eax, angle
      invoke FixedSin, eax
      mov sina, eax
;;=========================


      ;;set esi to the bitmap pointer
      mov esi, lpBmp
      lea edi, (EECS205BITMAP PTR [esi]).lpBytes

;=======================
      ;;set transparency
      xor eax, eax
	mov bTransparent, 0
      mov al, (EECS205BITMAP PTR [esi]).bTransparent
      mov bTransparent, eax;;
;;==============================      
      ;;determine shiftX
      mov ebx, (EECS205BITMAP PTR [esi]).dwWidth
      mov ecx, cosa
      sar ecx, 1
      invoke INT_FXPT_MULT, ebx, ecx
      mov shiftX, eax;; shiftX = dwWidth * (cosa/2)
      
      mov ebx, (EECS205BITMAP PTR [esi]).dwHeight
      mov ecx, sina
      sar ecx, 1
      invoke INT_FXPT_MULT, ebx, ecx
      sub shiftX, eax;; shiftX = dwWidth * (cosa/2) - dwHeight * (sina/2)

      ;;determine shiftY
      mov ebx, (EECS205BITMAP PTR [esi]).dwHeight
      mov ecx, cosa
      sar ecx, 1
      invoke INT_FXPT_MULT, ebx, ecx
      mov shiftY, eax;; shiftY = dwHeight * (cosa/2)
      
      mov ebx, (EECS205BITMAP PTR [esi]).dwWidth
      mov ecx, sina
      sar ecx, 1
      invoke INT_FXPT_MULT, ebx, ecx
      add shiftY, eax;; shiftY = dwHeight * (cosa/2) + dwWidth * (sina/2)
;;===================================

      ;;determine dstWidth & dstHeight
      mov ebx, (EECS205BITMAP PTR [esi]).dwWidth
      mov dstWidth, ebx
      mov dstHeight, ebx
      mov ebx, (EECS205BITMAP PTR [esi]).dwHeight
      add dstWidth, ebx
      add dstHeight, ebx

;;===================================
      ;;initialize outer loop parameters
      mov eax, dstWidth
      neg eax;
      mov dstX, eax
      jmp DSTX_C

DSTX_L:

      ;;initialize inner loop parameters
      mov eax, dstHeight
      neg eax
      mov dstY, eax
      jmp DSTY_C

;;MEAT OF THE LOOPS
DSTY_L:
      ;;calculate srcX
      mov eax, dstX
      mov edx, cosa
      invoke INT_FXPT_MULT, eax, edx
      mov srcX, eax

      mov eax, dstY
      mov edx, sina
      invoke INT_FXPT_MULT, eax, edx
      add srcX, eax

      ;;calculate srcY
      mov eax, dstY
      mov edx, cosa
      invoke INT_FXPT_MULT, eax, edx
      mov srcY, eax

      mov eax, dstX
      mov edx, sina
      invoke INT_FXPT_MULT, eax, edx
      sub srcY, eax

      ;;BIG CONDITIONS
      cmp srcX, 0
      jl CONTINUE

      cmp srcY, 0
      jl CONTINUE

      mov eax, (EECS205BITMAP PTR [esi]).dwWidth
      cmp srcX, eax
      jnl CONTINUE

      mov eax, (EECS205BITMAP PTR [esi]).dwHeight
      cmp srcY, eax
      jnl CONTINUE
;===
      ;FINAL CHECK FOR TRANSPARENCY
      xor eax, eax
      mov eax, srcY;; set eax to the row index
      mov edx, (EECS205BITMAP PTR [esi]).dwWidth;; mutliply eax by the width of each row
      imul edx;
      add eax, srcX;; add to eax the column index

      add eax, lpBmp;; determine location of the colors array
      add eax, 16;; start of lpBytes

      movzx edx, BYTE PTR [eax];; place the color into edx
      cmp edx, bTransparent;;
      je CONTINUE
      
      ;;FINALLY DRAW A DAMN PIXEL!!!!
      ;;(x, y) coordinates - x->(ebx); y->(ecx)
      mov ebx, xcenter
      add ebx, dstX
      sub ebx, shiftX

      mov ecx, ycenter
      add ecx, dstY
      sub ecx, shiftY

      invoke DrawPixel, ebx, ecx, edx

CONTINUE:

;;INNER FOR LOOP CONDITIONS
      inc edi;; increment color pointer
      inc dstY
DSTY_C:
      mov eax, dstHeight
      cmp dstY, eax
      jl DSTY_L


;;OUTER FOR LOOP CONDITIONS
      inc dstX
DSTX_C:
      mov eax, dstWidth
      cmp dstX, eax
      jl DSTX_L




	ret 			; Don't delete this line!!!		
RotateBlit ENDP



END
