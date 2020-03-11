; #########################################################################
;
;   lines.asm - Assembly file for CompEng205 Assignment 2
;	name: Ethan Solomon
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include ./Include/stars.inc
include ./Include/lines.inc

.DATA

	;; If you need to, you can place global variables here
	
.CODE
	

;; Don't forget to add the USES the directive here
;;   Place any registers that you modify (either explicitly or implicitly)
;;   into the USES list so that caller's values can be preserved
	
;;   For example, if your procedure uses only the eax and ebx registers
;;      DrawLine PROC USES eax ebx x0:DWORD, y0:DWORD, x1:DWORD, y1:DWORD, color:DWORD

	;; Feel free to use local variables...declare them here
	;; For example:
	;; 	LOCAL foo:DWORD, bar:DWORD
	
	;; Place your code here

DrawLine PROC USES eax ebx ecx edx esi edi x0:DWORD, y0:DWORD, x1:DWORD, y1:DWORD, color:DWORD
	LOCAL inc_x:DWORD, inc_y:DWORD, err:DWORD, prev_err:DWORD ;;Local variables for the procedure
	
	;;compute |x1-x0| -> store delta_x in ecx
	mov ebx, x1
	sub ebx, x0
	cmp ebx, 0
	jnl DXPOS
	neg ebx
DXPOS:
	mov ecx, ebx

	;;compute |y1-y0| -> store delta_y in edx
	mov ebx, y1
	sub ebx, y0
	cmp ebx, 0
	jnl DYPOS
	neg ebx
DYPOS:
	mov edx, ebx

	;;set increments
	mov inc_x, 1
	mov ebx, x0
	cmp ebx, x1
	jl INCXPOS
	sub inc_x, 2;;if x0 >= x1, then inc_x = -1
INCXPOS:
	mov inc_y, 1
	mov ebx, y0
	cmp ebx, y1
	jl INCYPOS
	sub inc_y, 2;;if y0 >= y1, then inc_y = -1
INCYPOS:

	cmp ecx, edx
	jle ERRNEG
	mov err, ecx
	shr err, 1
	jmp ERRPOS
ERRNEG:
	mov err, edx
	sar err, 1
	neg err
ERRPOS:



	;;DRAWLINE LOOP
	;; curr_x sits in %esi
	;; curr_y sits in %edi
	;; delta_x sits in %ecx
	;; delta_y sits in %edx

	mov esi, x0
	mov edi, y0

 	invoke DrawPixel, esi, edi, 8

	jmp CONDITION
DRAWLOOP:
	invoke DrawPixel, esi, edi, color
	mov ebx, err
	mov prev_err, ebx

	mov ebx, ecx
	neg ebx
	cmp prev_err, ebx
	jle NEXT
	sub err, edx
	add esi, inc_x

NEXT:
	cmp prev_err, edx
	jge CONDITION
	add err, ecx
	add edi, inc_y


CONDITION:
	cmp esi, x1
	jne DRAWLOOP
	cmp edi, y1
	jne DRAWLOOP

	ret
DrawLine ENDP




END
